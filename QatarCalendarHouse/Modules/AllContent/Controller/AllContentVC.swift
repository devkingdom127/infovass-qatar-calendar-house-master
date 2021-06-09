//
//  AllContentVC.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/28/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit
import PromiseKit

class AllContentVC: UIViewController, Storyboarded {
    
    //MARK: - Outlets
    
    @IBOutlet weak var buttonGregorianCalendar: UIButton!
    @IBOutlet weak var buttonHijriCalendar: UIButton!
    @IBOutlet weak var buttonAstronomicalSystems: UIButton!
    @IBOutlet weak var buttonAstronomicalApprovals: UIButton!
    @IBOutlet var collectionAllCategoriesButtons: [UIButton]!
    @IBOutlet weak var labelSubTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    
    private let model = AllContentModel()
    private var selectedCategory: ContentType! {
        didSet {
            self.labelSubTitle.text = self.selectedCategory.rawValue
            switch self.selectedCategory {
            case .gregorianCalendar:
                self.tableView.dataSource = gregorianCalendarAllContentTableDataSource
            case .hijriCalendar:
                self.tableView.dataSource = hijriCalendarAllContentTableDataSource
            case .astronomicalSystems:
                self.tableView.dataSource = astronomicalSystemsAllContentTableDataSource
            case .astronomicalApprovals:
                self.tableView.dataSource = astronomicalApprovalsAllContentTableDataSource
            default:
                self.selectedCategory = .gregorianCalendar
            }
            self.tableView.reloadData()
        }
    }
    private var gregorianCalendarAllContentTableDataSource: ContentTableDataSource!
    private var hijriCalendarAllContentTableDataSource: ContentTableDataSource!
    private var astronomicalSystemsAllContentTableDataSource: AstronomiesTableDataSource!
    private var astronomicalApprovalsAllContentTableDataSource: AstronomiesTableDataSource!
    private var allContentTableDelegate: ContentTableDelegate!
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.startLoading(shouldFreeze: false)
        firstly {
            when(fulfilled: model.requestAllContent(), model.requestAstronomies())
        }.done { [weak self] in
            guard let `self` = self else { return }
            self.setupTableView(with: $0, and: $1, for: self.tableView)
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
    
    @IBAction func onChooseCategoryButtonPressed(_ sender: UIButton) {
        collectionAllCategoriesButtons.forEach { $0.isSelected = false }
        sender.isSelected.toggle()
        if sender == buttonGregorianCalendar {
            selectedCategory = .gregorianCalendar
        } else if sender == buttonHijriCalendar {
            selectedCategory = .hijriCalendar
        } else if sender == buttonAstronomicalSystems {
            selectedCategory = .astronomicalSystems
        } else if sender == buttonAstronomicalApprovals {
            selectedCategory = .astronomicalApprovals
        }
    }
    
    //MARK: - Helpers

    private func setupTableView(with items: [ContentItem], and astronomies: [Astronomy], for tableView: UITableView) {
        
        let _ = setupDataSource(with: items, and: .gregorianCalendar)
        let _ = setupDataSource(with: items, and: .hijriCalendar)
        let _ = setupDataSource(with: astronomies, and: .astronomicalApprovals)
        let _ = setupDataSource(with: astronomies, and: .astronomicalSystems)

        allContentTableDelegate = ContentTableDelegate()
        tableView.delegate = allContentTableDelegate
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.separatorStyle = .none
        tableView.register(R.nib.imageCell)
        tableView.register(R.nib.textCell)
        tableView.register(R.nib.fileCell)
        tableView.register(R.nib.astronomyCell)
        self.onChooseCategoryButtonPressed(buttonGregorianCalendar)
    }
    
    private func setupDataSource(with items: [ContentItem], and contentType: ContentType) -> Bool {
        let item = items.filter {
            guard let type = $0.type else { return false }
            return type == contentType
        }.first

        guard let finalItem = item else { return false }
        switch contentType {
        case .gregorianCalendar:
            self.gregorianCalendarAllContentTableDataSource = ContentTableDataSource(with: finalItem, assetService: model)
        case .hijriCalendar:
            self.hijriCalendarAllContentTableDataSource = ContentTableDataSource(with: finalItem, assetService: model)
        default: return false
        }
        return true
    }
    
    private func setupDataSource(with items: [Astronomy], and contentType: ContentType) -> Bool {
        let items = items.filter {
            guard let type = $0.type else { return false }
            return type == contentType
        }

        switch contentType {
        case .astronomicalSystems:
            self.astronomicalSystemsAllContentTableDataSource = AstronomiesTableDataSource(with: items)
        case .astronomicalApprovals:
            self.astronomicalApprovalsAllContentTableDataSource = AstronomiesTableDataSource(with: items)
        default: return false
        }
        return true
    }

}
