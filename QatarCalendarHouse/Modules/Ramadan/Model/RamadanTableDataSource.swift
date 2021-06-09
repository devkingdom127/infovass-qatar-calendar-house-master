//
//  RamadanTableDataSource.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 3/25/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit

class RamadanTableDataSource: NSObject, UITableViewDataSource {
    
    //MARK: - Properties
    
    var calendars: [DayCalendar]
    
    //MARK: - Initializers
    
    init(calendars: [DayCalendar]) {
        self.calendars = calendars.sorted { $0.date.toDate()! < $1.date.toDate()! }
        super.init()
    }
    
    //MARK: - DataSource
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        calendars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ramadanPrayersTimeCell, for: indexPath) else {
            return UITableViewCell()
        }
//        if indexPath.row == 0 {
//            cell.configureAsHeader()
//        } else {
        cell.configure(with: calendars[indexPath.row], rowNumber: indexPath.row + 1)
//        }
        return cell
    }

    //MARK: - Helpers
    
    
}
