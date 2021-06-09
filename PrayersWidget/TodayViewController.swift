//
//  TodayViewController.swift
//  PrayersWidget
//
//  Created by Moahmmed Sami on 19/12/2020.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit
import NotificationCenter
import PromiseKit
import CountdownLabel

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var labelDayOfWeek: UILabel!
    @IBOutlet weak var labelDayHijri: UILabel!
    @IBOutlet weak var labelMonthHijri: UILabel!
    @IBOutlet weak var labelYearHijri: UILabel!
    @IBOutlet weak var labelDayGregorian: UILabel!
    @IBOutlet weak var labelMonthGregorian: UILabel!
    @IBOutlet weak var labelYearGregorian: UILabel!
    @IBOutlet weak var labelFajr: UILabel!
    @IBOutlet weak var labelShrouk: UILabel!
    @IBOutlet weak var labelZuhr: UILabel!
    @IBOutlet weak var labelAsr: UILabel!
    @IBOutlet weak var labelMaghrib: UILabel!
    @IBOutlet weak var labelEshaa: UILabel!
    @IBOutlet weak var nearstPrayer: UILabel!
    @IBOutlet weak var nearstPrayerTime: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var nearestPrayerRemainingTime: CountdownLabel!
    @IBOutlet weak var countDownTimer: SRCountdownTimer!
    @IBOutlet weak var labelFajrTitle: UILabel!
    @IBOutlet weak var labelShroukTitle: UILabel!
    @IBOutlet weak var labelZuhrTitle: UILabel!
    @IBOutlet weak var labelAsrTitle: UILabel!
    @IBOutlet weak var labelMaghribTitle: UILabel!
    @IBOutlet weak var labelEshaaTitle: UILabel!

    var dayCalendar: DayCalendar?

    private lazy var remoteAPI: QCHRemoteAPI = {
        let remote = QCHRemoteAPIImpl()
        return remote
    }()
    private lazy var refresher: NotificationRefresher = {
        let refresher = NotificationsModel()
        return refresher
    }()
    
    private lazy var dailyCalendarRepo: DailyCalendarRepository = {
        let repo = QCHDailyCalendarRepository(remoteAPI: remoteAPI, notificationRefresher: refresher)
        return repo
    }()

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        let userInterfaceStyle = traitCollection.userInterfaceStyle // Either .unspecified, .light, or .dark
        backgroundImageView.image = userInterfaceStyle == .dark ? nil : UIImage(named: "background.png")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImageView.image = UIImage(named: "background.png")
        backgroundImageView.backgroundColor = #colorLiteral(red: 0.1411764706, green: 0.1411764706, blue: 0.1411764706, alpha: 1)
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        labelDayOfWeek.textColor = UIColor(named: "primary")
        countDownTimer.isLabelHidden = true
        countDownTimer.lineWidth = 8
        countDownTimer.lineColor = UIColor(named: "primary") ?? #colorLiteral(red: 0.5450980392, green: 0.007843137255, blue: 0.3411764706, alpha: 1)
        countDownTimer.trailLineColor = UIColor(named: "darkGray") ?? #colorLiteral(red: 0.3411764706, green: 0.3411764706, blue: 0.3411764706, alpha: 1)
        labelDayOfWeek.text = ""
        labelDayHijri.text = ""
        labelMonthHijri.text = ""
        labelYearHijri.text = ""
        labelDayGregorian.text = ""
        labelMonthGregorian.text = ""
        labelYearGregorian.text = ""
        labelFajr.text = ""
        labelShrouk.text = ""
        labelZuhr.text = ""
        labelAsr.text = ""
        labelMaghrib.text = ""
        labelEshaa.text = ""
        nearstPrayer.text = ""
        nearstPrayerTime.text = ""
        nearestPrayerRemainingTime.text = ""
        nearestPrayerRemainingTime.countdownDelegate = self
        checkDayCalendarValidity(dayCalendar: dayCalendar)
    }
    
    func checkDayCalendarValidity(dayCalendar: DayCalendar?) {
        let today = Date()
        let userDefaults = UserDefaults.standard
        let date = userDefaults.string(forKey: "date")
        if today.stringFormatted() == date {
            let cachedDayCalendar = DayCalendar(id: userDefaults.integer(forKey: "id"), date: date ?? "", dayName: nil, fajr: userDefaults.string(forKey: "fajr") ?? "", shrouk: userDefaults.string(forKey: "shrouk") ?? "", zuhr: userDefaults.string(forKey: "zuhr") ?? "", asr: userDefaults.string(forKey: "asr") ?? "", maghrib: userDefaults.string(forKey: "maghrib") ?? "", eshaa: userDefaults.string(forKey: "eshaa") ?? "", midNight: nil, lastThird: nil, mawasem: nil, suhail: nil, borgName: nil, borgNum: nil, talaName: nil, talaNum: nil, dayContent: nil, dayPhenomena: nil, hijriDate: nil, hijriYear: nil, hijriMonth: nil, hijriDay: nil, shoroukTime: nil, ghoroubTime: nil)
            fillDate(dayCalendar: cachedDayCalendar)
        } else {
            getData()
        }
    }
    
    @objc private func getData() {
        DispatchQueue.global(qos: .userInitiated).async {
            firstly {
                self.dailyCalendarRepo.getCurrentDayCalendar(date: Date(), forceReload: true, shouldCache: false)
            }.done(on: .main) { [weak self] in
                let userDefaults = UserDefaults.standard
                userDefaults.set($0.id, forKey: "id")
                userDefaults.set($0.date, forKey: "date")
                userDefaults.set($0.fajr, forKey: "fajr")
                userDefaults.set($0.shrouk, forKey: "shrouk")
                userDefaults.set($0.zuhr, forKey: "zuhr")
                userDefaults.set($0.asr, forKey: "asr")
                userDefaults.set($0.maghrib, forKey: "maghrib")
                userDefaults.set($0.eshaa, forKey: "eshaa")
                self?.dayCalendar = $0
                self?.fillDate(dayCalendar: $0)
            }.catch(on: .main) {
                print($0.localizedDescription)
            }
        }
    }
    
    func fillDate(dayCalendar: DayCalendar) {
        labelDayOfWeek.text = dayCalendar.date.toDate()?.arabicDayNameFormatted()
        let formattedDateHijri = dayCalendar.date.toDate()?.hijriDateFormatted().toEnglishNumbers().split(separator: "-") ?? []
        let formattedDateGregorian = dayCalendar.date.toDate()?.gregorianDateFormatted().toEnglishNumbers().split(separator: "-") ?? []
        labelDayHijri.text = String(formattedDateHijri[0])
        labelMonthHijri.text = String(formattedDateHijri[1])
        labelYearHijri.text = String(formattedDateHijri[2]).replacingOccurrences(of: "هـ", with: "")
        labelDayGregorian.text = String(formattedDateGregorian[0])
        labelMonthGregorian.text = String(formattedDateGregorian[1])
        labelYearGregorian.text = String(formattedDateGregorian[2]).replacingOccurrences(of: "م", with: "")
//        labelHijri.text = String(formattedDateHijri.joined(separator: " ") ?? "").replacingOccurrences(of: "هـ", with: "")
//        labelGregorian.text = String(formattedDateGregorian?.joined(separator: " ") ?? "").replacingOccurrences(of: "م", with: "")
        labelFajr.text = dayCalendar.fajr.toFormattedTime()
        labelShrouk.text = dayCalendar.shrouk.toFormattedTime()
        labelZuhr.text = dayCalendar.zuhr.toFormattedTime()
        labelAsr.text = dayCalendar.asr.toFormattedTime()
        labelMaghrib.text = dayCalendar.maghrib.toFormattedTime()
        labelEshaa.text = dayCalendar.eshaa.toFormattedTime()
        detectNextParyer(calendar: dayCalendar)
    }
    
    func detectNextParyer(calendar: DayCalendar) {
        resetPrayersBackground()
        let fajrDate = "\(calendar.date) \(calendar.fajr) GMT+03:00".toPrayDate()
        let shroukDate = "\(calendar.date) \(calendar.shrouk) GMT+03:00".toPrayDate()
        let zuhrDate = "\(calendar.date) \(calendar.zuhr) GMT+03:00".toPrayDate()
        let asrDate = "\(calendar.date) \(calendar.asr) GMT+03:00".toPrayDate()
        let maghribDate = "\(calendar.date) \(calendar.maghrib) GMT+03:00".toPrayDate()
        let eshaaDate = "\(calendar.date) \(calendar.eshaa) GMT+03:00".toPrayDate()
        let now = Date()
        let fajr = Int(fajrDate!.timeIntervalSince(now))
        let shrouk = Int(shroukDate!.timeIntervalSince(now))
        let zuhr = Int(zuhrDate!.timeIntervalSince(now))
        let asr = Int(asrDate!.timeIntervalSince(now))
        let maghrib = Int(maghribDate!.timeIntervalSince(now))
        let eshaa = Int(eshaaDate!.timeIntervalSince(now))
        var nearst = getMinNumber(numbers: [fajr, shrouk, zuhr, asr, maghrib, eshaa]) ?? 0
        var totalTime = 0
        if nearst == fajr {
            nearstPrayer.text = "الفجر"
            labelFajr.textColor = UIColor(named: "primary")
            labelFajrTitle.textColor = UIColor(named: "primary")
            nearstPrayerTime.text = calendar.fajr.toFormattedTime()
            if let fajr = fajrDate, let previousEshaaDate = Calendar.current.date(byAdding: .day, value: -1, to: eshaaDate!) {
                totalTime = Int(fajr.timeIntervalSince(previousEshaaDate))
            }
        } else if nearst == shrouk {
            nearstPrayer.text = "الشروق"
            labelShrouk.textColor = UIColor(named: "primary")
            labelShroukTitle.textColor = UIColor(named: "primary")
            nearstPrayerTime.text = calendar.shrouk.toFormattedTime()
            if let first = fajrDate, let second = shroukDate {
                totalTime = Int(second.timeIntervalSince(first))
            }
        } else if nearst == zuhr {
            nearstPrayer.text = "الظهر"
            labelZuhr.textColor = UIColor(named: "primary")
            labelZuhrTitle.textColor = UIColor(named: "primary")
            nearstPrayerTime.text = calendar.zuhr.toFormattedTime()
            if let first = shroukDate, let second = zuhrDate {
                totalTime = Int(second.timeIntervalSince(first))
            }
        } else if nearst == asr {
            nearstPrayer.text = "العصر"
            labelAsr.textColor = UIColor(named: "primary")
            labelAsrTitle.textColor = UIColor(named: "primary")
            nearstPrayerTime.text = calendar.asr.toFormattedTime()
            if let first = zuhrDate, let second = asrDate {
                totalTime = Int(second.timeIntervalSince(first))
            }
        } else if nearst == maghrib {
            nearstPrayer.text = "المغرب"
            labelMaghrib.textColor = UIColor(named: "primary")
            labelMaghribTitle.textColor = UIColor(named: "primary")
            nearstPrayerTime.text = calendar.maghrib.toFormattedTime()
            if let first = asrDate, let second = maghribDate {
                totalTime = Int(second.timeIntervalSince(first))
            }
        } else if nearst == eshaa {
            nearstPrayer.text = "العشاء"
            labelEshaa.textColor = UIColor(named: "primary")
            labelEshaaTitle.textColor = UIColor(named: "primary")
            nearstPrayerTime.text = calendar.eshaa.toFormattedTime()
            if let first = maghribDate, let second = eshaaDate {
                totalTime = Int(second.timeIntervalSince(first))
            }
        } else {
            nearstPrayer.text = "الفجر"
            labelFajr.textColor = UIColor(named: "primary")
            labelFajrTitle.textColor = UIColor(named: "primary")
            nearstPrayerTime.text = calendar.fajr.toFormattedTime()
            if let nextFajrDate = Calendar.current.date(byAdding: .day, value: 1, to: fajrDate!) {
                nearst = Int(nextFajrDate.timeIntervalSince(now))
                if let eshaaDate = eshaaDate {
                    totalTime = Int(nextFajrDate.timeIntervalSince(eshaaDate))
                }
            }
        }
        nearestPrayerRemainingTime.setCountDownTime(minutes: TimeInterval(nearst))
        nearestPrayerRemainingTime.start()
        countDownTimer.start(beginingValue: totalTime, elapsedTimeCounter: TimeInterval(totalTime - nearst))
    }
    
    func resetPrayersBackground() {
        labelFajr.textColor = UIColor(named: "black")
        labelFajrTitle.textColor = UIColor(named: "black")
        labelShrouk.textColor = UIColor(named: "black")
        labelShroukTitle.textColor = UIColor(named: "black")
        labelZuhr.textColor = UIColor(named: "black")
        labelZuhrTitle.textColor = UIColor(named: "black")
        labelAsr.textColor = UIColor(named: "black")
        labelAsrTitle.textColor = UIColor(named: "black")
        labelMaghrib.textColor = UIColor(named: "black")
        labelMaghribTitle.textColor = UIColor(named: "black")
        labelEshaa.textColor = UIColor(named: "black")
        labelEshaaTitle.textColor = UIColor(named: "black")
    }
    
    private func getMinNumber(numbers: [Int]) -> Int? {
        return numbers.filter({ $0 > 0 }).min()
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
      let expanded = activeDisplayMode == .expanded
      preferredContentSize = expanded ? CGSize(width: maxSize.width, height: 170) : maxSize
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        checkDayCalendarValidity(dayCalendar: dayCalendar)
        completionHandler(NCUpdateResult.newData)
    }
}

extension TodayViewController: CountdownLabelDelegate {
    
    func countdownFinished() {
        checkDayCalendarValidity(dayCalendar: dayCalendar)
    }
}
