//
//  BorgAndTalaTableDelegate.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 3/1/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit

class BorgAndTalaTableDelegate: NSObject, UITableViewDelegate {
    
    //MARK: - Properties
    
    var delegate: BorgAndTalaAndSuhailDelegate?
    
    //MARK: - Initializers
    
    init(delegate: BorgAndTalaAndSuhailDelegate?) {
        self.delegate = delegate
    }
    
    //MARK: - Delegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? AstrologicalCell,
            let content = cell.item else { return }
        delegate?.gotoAstrologicalDetails(content: content)
    }
        
    //MARK: - Helpers
    
    
}
