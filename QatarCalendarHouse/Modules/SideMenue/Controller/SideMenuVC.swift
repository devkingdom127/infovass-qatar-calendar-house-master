//
//  SideMenuVC.swift
//  OffaratMasr
//
//  Created by Amr Salman on 12/31/19.
//  Copyright © 2019 Infovass. All rights reserved.
//

import UIKit

class SideMenuVC: UIViewController, Storyboarded {
    
    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
        
    var delegate: SideMenuDelegate?
    var model = SideMenuModel()
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    //MARK: - Actions
    
    @IBAction func onDismissButtonPressed(_ sender: UIButton) {
        delegate?.gotoHome()
    }
    
    //MARK: - Helpers
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
        tableView.semanticContentAttribute = .forceRightToLeft
        tableView.register(R.nib.sideMenuCell)
    }
}

extension SideMenuVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        switch indexPath.row {
        case 0: delegate?.gotoHome()
        case 1: delegate?.gotoCalendars()
        case 2: delegate?.gotoBorgAndTalaAndSuhail()
        case 3: delegate?.gotoMonthlyCalendar()
        case 4: delegate?.gotoVacations()
        case 5: delegate?.gotoPrayerTimes()
        case 6: delegate?.gotoAllContent()
        case 7: delegate?.gotoQibla()
        case 8: delegate?.gotoRamadan()
        case 9: delegate?.gotoNotifications()
        case 10: delegate?.gotoAboutUs()
        case 11: delegate?.gotoContactUs()
        default: break
        }
    }
}

extension SideMenuVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.sideMenuCell, for: indexPath) else { return UITableViewCell()}
        
        cell.configure(with: model.items[indexPath.row])
        
        return cell
    }
}

protocol SideMenuDelegate {
    func gotoHome()
    func gotoQibla()
    func gotoPrayerTimes()
    func gotoVacations()
    func gotoNotifications()
    func gotoRamadan()
    func gotoCalendars()
    func gotoBorgAndTalaAndSuhail()
    func gotoAllContent()
    func gotoMonthlyCalendar()
    func gotoAboutUs()
    func gotoContactUs()
}
