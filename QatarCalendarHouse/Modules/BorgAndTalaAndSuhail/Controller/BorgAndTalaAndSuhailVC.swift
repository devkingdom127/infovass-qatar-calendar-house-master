//
//  BorgAndTalaAndSuhailVC.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/29/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit
import PromiseKit

class BorgAndTalaAndSuhailVC: UIViewController, Storyboarded {
    
    //MARK: - Outlets
    
    @IBOutlet weak var segmentedControl: ADVSegmentedControl!
    @IBOutlet weak var textSuhail: UITextView!
    @IBOutlet weak var tableViewBorg: UITableView!
    @IBOutlet weak var tableViewTala: UITableView!
    @IBOutlet weak var viewNote: UIView!
    @IBOutlet weak var labelTalaNote: UILabel!
    @IBOutlet weak var labelBorgNote: UILabel!
    @IBOutlet weak var tableViewBackgroundImage: UIImageView!
    @IBOutlet weak var textViewViewBackgroundImage: UIImageView!
    
    @IBOutlet weak var headerViewBorgTala: UIStackView!
    @IBOutlet weak var labelNumber: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelNumberOfDays: UILabel!
    @IBOutlet weak var labelStartDate: UILabel!
    @IBOutlet weak var labelSuhail: UILabel!

    //MARK: - Properties
    
    var delegate: BorgAndTalaAndSuhailDelegate?
    private let model = BorgAndTalaAndSuhailModel()
    private var talaTableDataSource: BorgAndTalaTableDataSource?
    private var talaTableDelegate: BorgAndTalaTableDelegate?
    private var borgTableDataSource: BorgAndTalaTableDataSource?
    private var borgTableDelegate: BorgAndTalaTableDelegate?

    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestTalas()
        requestBorgs()
        requestSuhail()
        setupSegmentedControl()
        onSegmentedControlValueChanged(segmentedControl as Any)
    }
    
    //MARK: - Actions
    
    @IBAction func onCloseButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSegmentedControlValueChanged(_ sender: Any) {
        if segmentedControl.selectedItem == "سهيل"  {
            textSuhail.isHidden = false
            tableViewBorg.isHidden = true
            tableViewTala.isHidden = true
            headerViewBorgTala.isHidden = true
            viewNote.isHidden = true
            labelBorgNote.isHidden = true
            labelTalaNote.isHidden = true
            tableViewBackgroundImage.isHidden = true
            textViewViewBackgroundImage.isHidden = false
        } else if segmentedControl.selectedItem == "البروج" {
            textSuhail.isHidden = true
            tableViewBorg.isHidden = false
            tableViewTala.isHidden = true
            headerViewBorgTala.isHidden = false
            viewNote.isHidden = false
            labelBorgNote.isHidden = false
            labelTalaNote.isHidden = true
            tableViewBackgroundImage.isHidden = false
            textViewViewBackgroundImage.isHidden = true
            configureHeader(isBorg: true)
        } else if segmentedControl.selectedItem == "الطوالع" {
            textSuhail.isHidden = true
            tableViewBorg.isHidden = true
            tableViewTala.isHidden = false
            headerViewBorgTala.isHidden = false
            viewNote.isHidden = false
            labelBorgNote.isHidden = true
            labelTalaNote.isHidden = false
            tableViewBackgroundImage.isHidden = false
            textViewViewBackgroundImage.isHidden = true
            configureHeader(isBorg: false)
        } else {
            textSuhail.isHidden = true
            tableViewBorg.isHidden = true
            tableViewTala.isHidden = true
            headerViewBorgTala.isHidden = true
            viewNote.isHidden = true
            labelBorgNote.isHidden = true
            labelTalaNote.isHidden = true
            tableViewBackgroundImage.isHidden = true
            textViewViewBackgroundImage.isHidden = true
        }
    }

    //MARK: - Helpers
    
    private func requestBorgs() {
        self.startLoading(shouldFreeze: false)
        firstly {
            model.requestBorgs()
        }.then {
            self.setupTableView(with: $0, tableView: self.tableViewBorg)
        }.then { _ in
            self.model.requestBorgNote()
        }.done { [weak self] in
            self?.labelBorgNote.text = $0.description
        }.ensure { [weak self] in
            self?.stopLoading()
        }.catch { [weak self] in
            self?.stopLoading(withErrorMessage: $0.localizedDescription)
        }
    }
    
    private func requestTalas() {
        self.startLoading(shouldFreeze: false)
        firstly {
            model.requestTalas()
        }.then {
            self.setupTableView(with: $0, tableView: self.tableViewTala)
        }.then { _ in
            self.model.requestTalaNote()
        }.done { [weak self] in
            self?.labelTalaNote.text = $0.description
        }.ensure { [weak self] in
            self?.stopLoading()
        }.catch { [weak self] in
            self?.stopLoading(withErrorMessage: $0.localizedDescription)
        }
    }
    
    private func requestSuhail() {
        self.startLoading(shouldFreeze: false)
        firstly {
            model.requestSuhailContent()
        }.done { [weak self] in
            guard let `self` = self else { return }
            self.textSuhail.text = $0.description
            self.adjustUITextViewHeight(arg: self.textSuhail)
        }.ensure { [weak self] in
            self?.stopLoading()
        }.catch { [weak self] in
            self?.stopLoading(withErrorMessage: $0.localizedDescription)
        }
    }

    private func setupTableView(with item: [Astrological], tableView: UITableView) -> Promise<Void> {
        return Promise { seal in
            let tableDataSource = BorgAndTalaTableDataSource(with: item)
            let tableDelegate = BorgAndTalaTableDelegate(delegate: delegate)
            if item.first is Borg {
                self.borgTableDelegate = tableDelegate
                self.borgTableDataSource = tableDataSource
            } else {
                self.talaTableDelegate = tableDelegate
                self.talaTableDataSource = tableDataSource
            }
            tableView.delegate = tableDelegate
            tableView.dataSource = tableDataSource
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 600
            tableView.separatorStyle = .none
            tableView.register(R.nib.astrologicalCell)
            tableView.reloadData()
            seal.fulfill(())
        }
    }
    
    private func setupSegmentedControl() {
        segmentedControl.items = ["سهيل", "البروج", "الطوالع"].reversed()
        segmentedControl.selectedIndex = segmentedControl.items.count - 1
        segmentedControl.font = R.font.cairoBold(size: 15)
        segmentedControl.addTarget(self, action: #selector(onSegmentedControlValueChanged(_:)), for: .valueChanged)
    }
    
    func configureHeader(isBorg: Bool) {
        self.labelNumber.text = "الرقم"
        self.labelName.text = isBorg ? "اسم البرج" : "اسم الطالع"
        self.labelNumberOfDays.text = "عدد ايامه"
        self.labelStartDate.text = "يوافق ميلادياً"
        self.labelSuhail.text = "موافقته لسهيل"
        if UIScreen.main.bounds.size.width < 350 {
            self.labelSuhail.numberOfLines = 2
        }
    }

    func adjustUITextViewHeight(arg : UITextView) {
        if arg.frame.size.height >= arg.contentSize.height {
            arg.translatesAutoresizingMaskIntoConstraints = true
            arg.sizeToFit()
            arg.isScrollEnabled = false
        }
    }

}

protocol BorgAndTalaAndSuhailDelegate {
    func gotoAstrologicalDetails(content: Astrological)
}
