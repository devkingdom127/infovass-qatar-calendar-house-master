//
//  HomeDataSource.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/10/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit

class HomeTableDataSource: NSObject, UITableViewDataSource {
    
    //MARK: - Properties
    
    var homeVC: HomeVC
    var calendar: DayCalendar
    
    //MARK: - Initializers
    
    init(calendar: DayCalendar, homeVC: HomeVC) {
        self.homeVC = homeVC
        self.calendar = calendar
        super.init()
    }
    
    //MARK: - DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return HomeSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch HomeSection(rawValue: section) {
        case .season: return calendar.mawasem != nil && !(calendar.mawasem?.isEmpty ?? true) ? 1 : 0
        case .phenomena: return calendar.dayPhenomena != nil && !(calendar.dayPhenomena?.isEmpty ?? true) ? 1 : 0
        case .content: return calendar.dayContent != nil && !(calendar.dayContent?.isEmpty ?? true) ? 1 : 0
//        case .moonTime: return calendar.shoroukTime != nil || !(calendar.shoroukTime?.isEmpty ?? true) ? 1 : 0
        default: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch HomeSection(rawValue: indexPath.section) {
        case .date:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.homeDateCell, for: indexPath) else { return UITableViewCell() }
            cell.configure(with: calendar, delegate: homeVC)
            return cell
        case .borgAndTala:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.borgAndTalaCell, for: indexPath) else { return UITableViewCell() }
            cell.configure(with: calendar, delegate: homeVC)
            return cell
        case .masjidImage:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.masjidImageCell, for: indexPath) else { return UITableViewCell() }
            cell.configure(delegate: homeVC)
            return cell
        case .prayerTime:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.prayerTimesCell, for: indexPath) else { return UITableViewCell() }
            cell.configure(with: calendar)
            return cell
        case .season:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.seasonCell, for: indexPath) else { return UITableViewCell() }
            cell.configure(with: calendar)
            return cell
        case .content:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.dayContentCell, for: indexPath) else { return UITableViewCell() }
            cell.configure(with: calendar)
            return cell
        case .phenomena:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.dayPhenomenaCell, for: indexPath) else { return UITableViewCell() }
            cell.configure(with: calendar)
            return cell
        case .moonTime:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.moonTimeCell, for: indexPath) else { return UITableViewCell() }
            cell.configure(with: calendar)
            return cell
        case .none:
            return UITableViewCell()
        }
    }
    
    //MARK: - Helpers
    
    
}

enum HomeSection: Int, CaseIterable {
    case date, borgAndTala, masjidImage, prayerTime, season, content, phenomena, moonTime
}
