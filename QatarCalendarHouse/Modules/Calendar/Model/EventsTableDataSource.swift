//
//  EventsTableDataSource.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 3/3/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit

class EventsTableDataSource: NSObject, UITableViewDataSource {
    
    //MARK: - Properties
    
    var items: [Vacation]
    
    //MARK: - Initializers
    
    init(with items: [Vacation]) {
        self.items = items
        super.init()
    }
    
    //MARK: - DataSource
            
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.eventCell, for: indexPath) else { return UITableViewCell() }
        cell.configure(with: items[indexPath.row])
        return cell
    }

    //MARK: - Helpers
    
    
}
