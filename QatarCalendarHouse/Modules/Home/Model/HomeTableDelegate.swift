//
//  HomeDelegate.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/10/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit

class HomeTableDelegate: NSObject, UITableViewDelegate {
    
    //MARK: - Properties
    
    let delegate: HomeDelegate
    let date: Date
    
    //MARK: - Initializers
    
    init(delegate: HomeDelegate, date: Date = Date()) {
        self.delegate = delegate
        self.date = date
        super.init()
    }
    
    //MARK: - Delegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        switch HomeSection(rawValue: indexPath.section) {
        case .season: delegate.gotoMonthlyCalendar(for: .season, date: date)
        case .phenomena: delegate.gotoMonthlyCalendar(for: .phenomena, date: date)
        case .content:
            guard let cell = tableView.cellForRow(at: indexPath) as? DayContentCell else { return }
            delegate.gotoDayContent(cell.labelContent.text ?? "")
        default: break
        }
    }
        
    //MARK: - Helpers
    
    
}
