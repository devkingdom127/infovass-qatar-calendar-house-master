//
//  UserDefaultsExtension.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 3/5/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    var azanNotificationPreference: [NotificationType]? {
        set {
            self.set(newValue?.compactMap { $0.rawValue }, forKey: "azanNotificationPreference")
        }
        get {
            return self.stringArray(forKey: "azanNotificationPreference")?.compactMap { NotificationType(rawValue: $0) }
        }
    }
    
    var iqamaNotificationPreference: [NotificationType]? {
        set {
            self.set(newValue?.compactMap { $0.rawValue }, forKey: "iqamaNotificationPreference")
        }
        get {
            return self.stringArray(forKey: "iqamaNotificationPreference")?.compactMap { NotificationType(rawValue: $0) }
        }
    }
    
    var azanIqamaNotificationPreference: [String: Int] {
        set {
            self.set(newValue, forKey: "azanIqamaNotificationPreference")
        }
        get {
            (self.dictionary(forKey: "azanIqamaNotificationPreference") ?? [:]) as [String: Int]
        }
    }
    
    var offlineTablesVersion: [String: String] {
        set {
            self.set(newValue, forKey: "offlineTablesVersion")
        }
        get {
            (self.dictionary(forKey: "offlineTablesVersion") ?? [:]) as [String: String]
        }
    }

    var appearance: String {
        set {
            self.set(newValue, forKey: "appearance")
        }
        get {
            self.string(forKey: "appearance") ?? ""
        }
    }
    
    var azanSoundTurnOff: Bool {
        set {
            self.setValue(newValue, forKey: "azanSoundTurnOff")
        }
        get {
            return self.bool(forKey: "azanSoundTurnOff")
        }
    }
}
