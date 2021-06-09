//
//  AboutVC.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 3/2/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit
import PromiseKit

class AboutVC: UIViewController, Storyboarded {
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    
    private let model = AboutModel()
    private var tableDelegate: ContentTableDelegate!
    private var tableDataSource: ContentTableDataSource!

    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.startLoading(shouldFreeze: false)
        firstly {
            model.requestAllContent()
        }.done { [weak self] in
            guard let `self` = self else { return }
            self.setupTableView(with: $0, tableView: self.tableView)
        }.ensure { [weak self] in
            self?.stopLoading()
        }.catch { [weak self] in
            self?.stopLoading(withErrorMessage: $0.localizedDescription)
        }
        
    }
    
    //MARK: - Actions
    
    @IBAction func onCloseButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Helpers

    private func setupTableView(with item: ContentItem, tableView: UITableView) {
        tableDataSource = ContentTableDataSource(with: item, assetService: model)
        tableDelegate = ContentTableDelegate()
        tableView.delegate = tableDelegate
        tableView.dataSource = tableDataSource
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.separatorStyle = .none
        tableView.register(R.nib.imageCell)
        tableView.register(R.nib.textCell)
        tableView.register(R.nib.fileCell)
        tableView.reloadData()
    }

}
