//
//  NotificationManager.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 3/5/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation
import UserNotifications
import PromiseKit

class NotificationManager {
    
    //MARK: - Properties
    
    static let shared = NotificationManager()
    private let notificationCenter = UNUserNotificationCenter.current()
    private let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    
    //MARK: - Initializers
    
    private init() {
        
    }
        
    //MARK: - Helpers
        
    func newNotification(for type: NotificationType, at date: Date, repeats: Bool = false, isAzan: Bool, enabled: Bool) -> Promise<Void> {
        return Promise { seal in
            firstly {
                checkAuthorizationStatus()
            }.then(on: .global(qos: .background)) { _ in
                self.scheduleNotification(for: type, at: date, repeats: repeats, isAzan: isAzan, enabled: enabled)
            }.done(on: .main) {
                seal.fulfill(())
            }.catch(on: .main) {
                seal.reject($0)
            }
        }
    }
    
    func cancelPendingNotifications(for type: NotificationType, isAzan: Bool) -> Promise<Void> {
        return Promise { seal in
            self.notificationCenter.getPendingNotificationRequests(completionHandler: { requests in
                var identifiers = [String]()
                for request in requests {
                    if request.identifier.contains("\(type.rawValue)\(isAzan ? "azan" : "iqama")") {
                        identifiers.append(request.identifier)
                    }
                }
                self.notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
                seal.fulfill(())
            })
        }
    }
    
    func printAllPendingNotifications() {
        notificationCenter.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                print(request)
            }
        })
    }
        
    private func checkAuthorizationStatus() -> Promise<Bool> {
        return Promise { seal in
            DispatchQueue.main.async {
                self.notificationCenter.getNotificationSettings { (settings) in
                    switch settings.authorizationStatus {
                    case .notDetermined:
                        self.notificationCenter.requestAuthorization(options: self.options) { didAllow, error in
                            if let error = error {
                                seal.reject(error)
                            } else {
                                seal.fulfill(didAllow)
                            }
                        }
                    case .authorized, .provisional:
                        seal.fulfill(true)
                    case .denied:
                        seal.reject(NotificationError.denied)
                    @unknown default:
                        seal.reject(NotificationError.unknown)
                    }
                }
            }
        }
    }
    
    private func scheduleNotification(for type: NotificationType, at date: Date, repeats: Bool = false, isAzan: Bool, enabled: Bool) -> Promise<Void> {
        return Promise { seal in
            let request = UNNotificationRequest(identifier: "\(type.rawValue)\(isAzan ? "azan" : "iqama")\(date.hashValue)",
                                                content: notificationContent(for: type, isAzan:  isAzan, enabled: enabled),
                trigger: notificationTrigger(at: date, repeats: repeats))
            self.notificationCenter.add(request) { (error) in
                DispatchQueue.main.async {
                    if let error = error {
                        seal.reject(error)
                    } else {
                        seal.fulfill(())
                    }
                }
            }
        }
    }

    private func notificationContent(for type: NotificationType, isAzan: Bool, enabled: Bool) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = type.title(isAzan: isAzan)
        content.sound = isAzan ? UNNotificationSound(named: UNNotificationSoundName(rawValue: enabled ? "azan.caf" : "beeb.caf")) : UNNotificationSound(named: UNNotificationSoundName(rawValue: "iqama.caf"))
        return content
    }
    
    private func notificationTrigger(at date: Date, repeats: Bool) -> UNCalendarNotificationTrigger {
        let triggerDate = Calendar.current.dateComponents([.month,.day,.hour,.minute,.second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: repeats)
        return trigger
    }
}

enum NotificationType: String, CaseIterable {
    case fajr
    case zuhr
    case asr
    case maghrib
    case eshaa
    
    func title(isAzan: Bool) -> String {
        if isAzan {
            return "الآن وقت أذان صلاة \(displayTitle)"
        }
        return "الآن وقت إقامة صلاة \(displayTitle)"
    }
    
    var displayTitle: String {
        switch self {
        case .fajr: return "الفجر"
        case .zuhr: return "الظهر"
        case .asr: return "العصر"
        case .maghrib: return "المغرب"
        case .eshaa: return "العشاء"
        }
    }
}

enum NotificationError: Error {
    case denied
    case unknown
}
