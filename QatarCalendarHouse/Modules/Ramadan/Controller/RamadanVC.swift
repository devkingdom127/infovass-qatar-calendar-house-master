//
//  RamadanVC.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 3/3/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit
import PromiseKit
import KRProgressHUD

class RamadanVC: UIViewController, Storyboarded {

    
    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonPrint: UIButton!
    @IBOutlet weak var buttonDownload: UIButton!
    @IBOutlet weak var buttonShare: UIButton!
    @IBOutlet weak var ramadanYear: UILabel!

    //MARK: - Properties
    
    private let model = RamadanModel()
    private var tableDataSource: RamadanTableDataSource!
    private let tableDelegate = RamadanTableDelegate()
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ramadanYear.text = "رمضان \(model.ramadanYear) هـ"
        self.startLoading(shouldFreeze: false)
        firstly {
            when(fulfilled: model.requestRamadanCalendars(), model.requestRamadanCalendarCintent())
        }.done { [weak self] in
            guard let `self` = self else { return }
            self.setupTableView(with: $0, tableView: self.tableView)
            self.setupActions(with: $1)
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

    private func setupTableView(with items: [DayCalendar], tableView: UITableView) {
        tableDataSource = RamadanTableDataSource(calendars: items)
        tableView.delegate = tableDelegate
        tableView.dataSource = tableDataSource
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.separatorStyle = .none
        tableView.register(R.nib.ramadanPrayersTimeCell)
        tableView.reloadData()
    }
    
    private func setupActions(with item: ContentItem) {
        buttonPrint.isHidden = item.file == nil
        buttonShare.isHidden = buttonPrint.isHidden
        buttonDownload.isHidden = buttonPrint.isHidden
        
        buttonShare.addTargetClosure { [weak self] _ in
            let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            sheet.addAction(UIAlertAction(title: "صورة", style: .default, handler: { _ in
                guard let url = self?.model.getAssetURL(for: item.image ?? "") else { return }
                KRProgressHUD.show()
                DispatchQueue.global(qos: .userInitiated).async {
                    guard let data = try? Data(contentsOf: url) else { return }
                    DispatchQueue.main.async {
                        KRProgressHUD.dismiss()
                        self?.share(data, source: self?.buttonShare) { isSuccessful in
                            if isSuccessful {
                                self?.showCompleted { }
                            }
                        }
                    }
                }
            }))
            
            sheet.addAction(UIAlertAction(title: "ملف PDF", style: .default, handler: { _ in
                guard let url = self?.model.getAssetURL(for: item.file ?? "") else { return }
                KRProgressHUD.show()
                DispatchQueue.global(qos: .userInitiated).async {
                    guard let data = try? Data(contentsOf: url) else { return }
                    DispatchQueue.main.async {
                        KRProgressHUD.dismiss()
                        self?.share(data, source: self?.buttonShare) { isSuccessful in
                            if isSuccessful {
                                self?.showCompleted { }
                            }
                        }
                    }
                }
            }))
            
            sheet.addAction(UIAlertAction(title: "إلغاء", style: .cancel, handler: nil))
            self?.present(sheet, animated: true, completion: nil)
                
        }
        
        buttonPrint.addTargetClosure { [weak self] _ in
            guard let url = self?.model.getAssetURL(for: item.image ?? "") else { return }
            KRProgressHUD.show()
            DispatchQueue.global(qos: .userInteractive).async {
                guard let data = try? Data(contentsOf: url) else { return }
                DispatchQueue.main.async {
                    KRProgressHUD.dismiss()
                    if UIPrintInteractionController.canPrint(data) {
                        let printInfo = UIPrintInfo(dictionary: nil)
                        printInfo.jobName = url.lastPathComponent
                        printInfo.outputType = .photo
                        let printController = UIPrintInteractionController.shared
                        printController.printInfo = printInfo
                        printController.showsNumberOfCopies = false
                        printController.printingItem = data
                        printController.present(animated: true, completionHandler: nil)
                    }
                }
            }
        }
        
        buttonDownload.addTargetClosure { [weak self] _ in
            let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            sheet.addAction(UIAlertAction(title: "صورة", style: .default, handler: { _ in
                guard let url = self?.model.getAssetURL(for: item.image ?? "") else { return }
                KRProgressHUD.show()
                DispatchQueue.global(qos: .userInitiated).async {
                    guard let data = try? Data(contentsOf: url) else { return }
                    DispatchQueue.main.async {
                        KRProgressHUD.dismiss()
                        guard let image = UIImage(data: data) else { return }
                        if let `self` = self {
                            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
                        } else {
                            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                        }
                    }
                }
            }))
            
            sheet.addAction(UIAlertAction(title: "ملف PDF", style: .default, handler: { _ in
                guard let url = self?.model.getAssetURL(for: item.file ?? "") else { return }
                KRProgressHUD.show()
                DispatchQueue.global(qos: .userInitiated).async {
                    guard let data = try? Data(contentsOf: url) else { return }
                    DispatchQueue.main.async {
                        KRProgressHUD.dismiss()
                        self?.share(data, source: self?.buttonDownload) { isSuccessful in
                            if isSuccessful {
                                self?.showCompleted { }
                            }
                        }
                    }
                }
            }))
            
            sheet.addAction(UIAlertAction(title: "إلغاء", style: .cancel, handler: nil))
            self?.present(sheet, animated: true, completion: nil)
                
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            self.stopLoading(withErrorMessage: error.localizedDescription)
        } else {
            self.showCompleted { }
        }
    }
}
