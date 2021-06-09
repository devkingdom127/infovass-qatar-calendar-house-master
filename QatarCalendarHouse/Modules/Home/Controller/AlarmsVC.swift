//
//  AlarmsVC.swift
//  QatarCalendarHouse
//
//  Created by Moahmmed Sami on 24/12/2020.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit
import PromiseKit
import KRProgressHUD
import ReadMoreTextView

class AlarmsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var alarms = [Alarm]()
    var expandedCells = Set<Int>()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        requestAlarms()
    }
    
    override func viewDidLayoutSubviews() {
        tableView.reloadData()
    }

    private func requestAlarms() {
        KRProgressHUD.show()
        firstly {
            QCHRemoteAPIImpl().getAlarms()
        }.compactMap {
            $0.list
        }.done { [weak self] in
            self?.alarms = $0
            self?.tableView.reloadData()
            UserDefaults.standard.set($0.count, forKey: "lastReadAlarmsCount")
            UserDefaults.standard.synchronize()
        }.ensure {
            KRProgressHUD.dismiss()
        }.catch { [weak self] in
            KRProgressHUD.dismiss()
            self?.stopLoading(withErrorMessage: $0.localizedDescription)
        }
    }
    
    @IBAction func backPressed() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension AlarmsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath) as! AlarmCell
        cell.dateLabel.text = alarms[indexPath.row].updatedAt.toAlarmDate()?.alarmDateFormatted()
        cell.titleTextView.text = alarms[indexPath.row].title
        let readMoreTextView = cell.contentView.viewWithTag(1) as! ReadMoreTextView
        readMoreTextView.shouldTrim = !expandedCells.contains(indexPath.row)
        readMoreTextView.setNeedsUpdateTrim()
        readMoreTextView.layoutIfNeeded()
        return cell
    }
}

extension AlarmsVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let readMoreTextView = cell.contentView.viewWithTag(1) as! ReadMoreTextView
        readMoreTextView.onSizeChange = { [unowned tableView, unowned self] r in
            let point = tableView.convert(r.bounds.origin, from: r)
            guard let indexPath = tableView.indexPathForRow(at: point) else { return }
            if r.shouldTrim {
                self.expandedCells.remove(indexPath.row)
            } else {
                self.expandedCells.insert(indexPath.row)
            }
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        let readMoreTextView = cell.contentView.viewWithTag(1) as! ReadMoreTextView
        readMoreTextView.shouldTrim = !readMoreTextView.shouldTrim
    }
}
