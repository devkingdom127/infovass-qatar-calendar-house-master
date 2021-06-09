//
//  MonthlyCalendarTableDataSource.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 3/19/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit

class MonthlyCalendarTableDataSource: NSObject, UITableViewDataSource {
    
    //MARK: - Properties
    
    var calendars: [DayCalendar]
    var type: CalendarType
    
    //MARK: - Initializers
    
    init(calendars: [DayCalendar], type: CalendarType) {
        var tempCalendars = calendars
        switch type {
        case .phenomena: tempCalendars.removeAll { $0.dayPhenomena?.isEmpty ?? true || $0.dayPhenomena == "---" }
        case .season: tempCalendars.removeAll { $0.mawasem?.isEmpty ?? true || $0.mawasem == "---" }
        default: break
        }
        self.calendars = tempCalendars.sorted { $0.date.toDate()! < $1.date.toDate()! }
        self.type = type
        super.init()
    }
    
    //MARK: - DataSource
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        calendars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch type {
        case .phenomena, .season:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.monthlyCalendarPhenomenaCell, for: indexPath) else {
                return UITableViewCell()
            }
//            if indexPath.row == 0 {
//                cell.configureAsHeader(with: type)
//            } else {
                cell.configure(with: calendars[indexPath.row], rowNumber: indexPath.row + 1, type: type)
//            }
            return cell
        case .prayerTimes:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.monthlyCalendarPrayerTimesCell, for: indexPath) else {
                return UITableViewCell()
            }
//            if indexPath.row == 0 {
//                cell.configureAsHeader()
//            } else {
                cell.configure(with: calendars[indexPath.row], rowNumber: indexPath.row + 1)
//            }
            return cell
        @unknown default:
            return UITableViewCell()
        }
    }

    //MARK: - Helpers
    
    
}
