//
//  AppDataLoaderVC.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 4/19/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit
import PromiseKit

class AppDataLoaderVC: UIViewController, Storyboarded {

    //MARK: - Outlets
    
    
    //MARK: - Properties
    
    lazy var refresher: NotificationRefresher = {
        return NotificationsModel()
    }()
    
    lazy var model: ApplicationContentModel = {
        return ApplicationContentModel()
    }()
    
    var delegate: AppDataLoaderDelegate?
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        _ = model.configure()
    }
    
    //MARK: - Actions
    
    
    //MARK: - Helpers

}

protocol AppDataLoaderDelegate {
    func gotoHome()
}
