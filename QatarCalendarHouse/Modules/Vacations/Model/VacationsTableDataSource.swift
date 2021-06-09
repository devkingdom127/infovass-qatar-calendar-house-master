//
//  VacationsTableDataSource.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/26/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit

class VacationsTableDataSource: NSObject, UITableViewDataSource {
    
    //MARK: - Properties
    
    var vacations: [Vacation]
    
    //MARK: - Initializers
    
    init(vacations: [Vacation]) {
        self.vacations = vacations
        super.init()
    }
    
    //MARK: - DataSource
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vacations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.vacationCell, for: indexPath) else {
            return UITableViewCell()
        }
        cell.configure(with: vacations[indexPath.row])
        return cell
    }

    //MARK: - Helpers
    
    
}
