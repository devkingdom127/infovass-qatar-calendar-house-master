//
//  HomeVC.swift
//  OffaratMasr
//
//  Created by Amr Salman on 12/21/19.
//  Copyright © 2019 Infovass. All rights reserved.
//

import UIKit
import PromiseKit
import KRProgressHUD

class HomeVC: UIViewController, Storyboarded {
    
    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notificationsCountLabel: UILabel!

    //MARK: - Properties
    
    var delegate: HomeDelegate?
    var model = HomeModel()
    var tableDelegate: HomeTableDelegate!
    var tableDataSource: HomeTableDataSource!
    var currentDayIndex = 0
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.reload), name: NSNotification.Name(rawValue: "reload-home"), object: nil)
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNotificationsCount()
    }
    
    //MARK: - Actions
    
    @IBAction func onOpenMenuBtnPressed(_ sender: Any) {
        delegate?.gotoSideMenu()
    }
    
    @IBAction func onOpenNotificationsBtnPressed(_ sender: Any) {
        
    }

    @IBAction func onShareScreenshotBtnPressed(_ sender: Any) {
        if let screenshot = UIApplication.shared.keyWindow?.capture() {
            let activityViewController = UIActivityViewController(activityItems: [screenshot], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = view
            present(activityViewController, animated: true, completion: nil)
        }
    }

    @IBAction func onSettingsBtnPressed(_ sender: Any) {
        delegate?.gotoSettings()
    }

    //MARK: - Helpers

    @objc func reload(notif: NSNotification) {
        getData()
    }

    private func refresh() {
        let calendar = Calendar.current
        guard let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) else { return }
        guard let date = calendar.date(
            bySettingHour: 0,
            minute: 0,
            second: 0,
            of: tomorrow) else { return }
        
        let timer = Timer(fireAt: date, interval: 0, target: self, selector: #selector(getData), userInfo: nil, repeats: false)
        
        RunLoop.main.add(timer, forMode: .common)
    }
    
    private func setupTableView(with item: DayCalendar, date: Date = Date()) {
        tableDataSource = HomeTableDataSource(calendar: item, homeVC: self)
        tableDelegate = HomeTableDelegate(delegate: self.delegate!, date: date)
        tableView.delegate = tableDelegate
        tableView.dataSource = tableDataSource
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.separatorStyle = .none
        tableView.register(R.nib.dateCell)
        tableView.register(R.nib.borgAndTalaCell)
        tableView.register(R.nib.masjidImageCell)
        tableView.register(R.nib.prayerTimesCell)
        tableView.register(R.nib.dayContentCell)
        tableView.register(R.nib.dayPhenomenaCell)
        tableView.register(R.nib.seasonCell)
        tableView.register(R.nib.moonTimeCell)
        tableView.reloadData()
        KRProgressHUD.dismiss()
    }
    
    func updateNotificationsCount() {
        firstly {
            QCHRemoteAPIImpl().getAlarms()
        }.compactMap {
            $0.list
        }.done { [weak self] in
            let notReadNotificationsCount = $0.count - UserDefaults.standard.integer(forKey: "lastReadAlarmsCount")
            self?.notificationsCountLabel.text = notReadNotificationsCount > 0
                ? "\(notReadNotificationsCount)" : ""
        }
    }
    
    @objc private func getData(date: Date = Date()) {
        self.startLoading(shouldFreeze: false)
        KRProgressHUD.show()
        DispatchQueue.global(qos: .userInitiated).async {
            firstly {
                self.model.requestCalendar(date: date)
            }.done(on: .main) { [weak self] in
                self?.setupTableView(with: $0, date: date)
            }.ensure(on: .main) { [weak self] in
                self?.stopLoading()
            }.catch(on: .main) { [weak self] in
                self?.stopLoading(withErrorMessage: $0.localizedDescription)
            }
        }
        
        DispatchQueue.global(qos: .background).async {
            self.model.refreshNotifications()
        }
        
        refresh()
    }
    
}

extension HomeVC: DateCellDelegate {
    func didPressLogo() {
        delegate?.gotoAbout()
    }
}

extension HomeVC: MasjidImageCellDelegate {
    
    func previousPressed() {
        guard currentDayIndex > -7 else { return }
        currentDayIndex -= 1
        if let date = Calendar.current.date(byAdding: .day, value: currentDayIndex, to: Date()) {
            getData(date: date)
        }
    }
    
    func nextPressed() {
        guard currentDayIndex < 7 else { return }
        currentDayIndex += 1
        if let date = Calendar.current.date(byAdding: .day, value: currentDayIndex, to: Date()) {
            getData(date: date)
        }
    }
}

public extension UIWindow {
    
    func capture() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, self.isOpaque, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
  }
}

extension HomeVC: BorgAndTalaCellDelegate {
    func openBorg(named: String) {
        delegate?.gotoAstrologicalDetails(type: .borg(name: named))
    }
    
    func openTala(named: String) {
        delegate?.gotoAstrologicalDetails(type: .tala(name: named))
    }
    
    func openSuhail() {
        delegate?.gotoAstrologicalDetails(type: .suhail)
    }
}

protocol HomeDelegate {
    func gotoSideMenu()
    func gotoAbout()
    func gotoDayContent(_ content: String)
    func gotoMonthlyCalendar(for type: CalendarType, date: Date)
    func gotoAstrologicalDetails(type: AstrologicalType)
    func gotoSettings()
}
