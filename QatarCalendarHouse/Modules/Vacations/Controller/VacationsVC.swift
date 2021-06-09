//
//  VacationsVC.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/26/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit
import PromiseKit

class VacationsVC: UIViewController, Storyboarded {
    
    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonStaticVacations: UIButton!
    @IBOutlet weak var buttonAcadimicVacations: UIButton!
    @IBOutlet weak var textAcademicVacations: UITextView!
    @IBOutlet weak var academicVacationsDownload: UIButton!
    @IBOutlet var collectionButtonContent: [UIButton]!
    
    //MARK: - Properties
    
    private let model = VacationsModel()
    private var tableDataSource: VacationsTableDataSource!
    private let tableDelegate = VacationsTableDelegate()
    private var academicVacationsLink: URL?
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textAcademicVacations.font = R.font.cairoRegular(size: 17)
        academicVacationsDownload.tintColor = R.color.primary()
        academicVacationsDownload.setImage(R.image.download()?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.startLoading(shouldFreeze: false)
        firstly {
            model.requestVacations()
        }.then {
            self.setupTableView(with: $0)
        }.then {
            self.model.requestSchoolCalendar()
        }.done { [weak self] in
            self?.textAcademicVacations.text = $0.description
            if let file = $0.file, let url = URL(string: file, relativeTo: QCH.asset.assetURL) {
                self?.academicVacationsLink = url
            }
            self?.academicVacationsDownload.addTargetClosure { _ in
                guard let academicVacationsLink = self?.academicVacationsLink else { return }
                if UIApplication.shared.canOpenURL(academicVacationsLink) {
                    UIApplication.shared.open(academicVacationsLink, options: [:], completionHandler: nil)
                }
            }
        }.ensure { [weak self] in
            self?.stopLoading()
        }.catch { [weak self] in
            self?.stopLoading(withErrorMessage: $0.localizedDescription)
        }
    }
    
    //MARK: - Actions
    
    
    @IBAction func onChooseContentTypeButtonPressed(_ sender: UIButton) {
        self.collectionButtonContent.forEach { self.deactivate($0) }
        self.activate(sender)
        if sender.tag == 1 {
            tableView.isHidden = false
            textAcademicVacations.isHidden = true
            academicVacationsDownload.isHidden = true
        } else if sender.tag == 2 {
            tableView.isHidden = true
            textAcademicVacations.isHidden = false
            academicVacationsDownload.isHidden = academicVacationsLink == nil
        }
    }
    
    @IBAction func onCloseButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Helpers

    private func setupTableView(with item: [Vacation]) -> Promise<Void> {
        return Promise { seal in
            tableDataSource = VacationsTableDataSource(vacations: item)
            tableView.delegate = tableDelegate
            tableView.dataSource = tableDataSource
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 600
            tableView.separatorStyle = .none
            tableView.register(R.nib.vacationCell)
            tableView.reloadData()
            seal.fulfill(())
        }
    }

    private func activate(_ button: UIButton) {
        button.backgroundColor = R.color.primary()
        button.setTitleColor(.white, for: .normal)
    }
    
    private func deactivate(_ button: UIButton) {
        button.backgroundColor = R.color.secondaryBackground()
        button.setTitleColor(R.color.primary(), for: .normal)
    }
}
