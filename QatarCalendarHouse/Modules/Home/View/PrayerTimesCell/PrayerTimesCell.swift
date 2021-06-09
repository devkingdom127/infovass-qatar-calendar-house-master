//
//  PrayerTimesCell.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/20/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit

class PrayerTimesCell: UITableViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet var labelLine: [UILabel]!
    @IBOutlet weak var labelFajr: UILabel!
    @IBOutlet weak var labelShrouk: UILabel!
    @IBOutlet weak var labelZuhr: UILabel!
    @IBOutlet weak var labelAsr: UILabel!
    @IBOutlet weak var labelMaghrib: UILabel!
    @IBOutlet weak var labelEshaa: UILabel!
    @IBOutlet weak var labelMidNight: UILabel!
    @IBOutlet weak var labelLastThird: UILabel!

    //MARK: - Properties
    
    
    //MARK: - Configuration
    
    func configure(with item: DayCalendar) {
        labelFajr.text = item.fajr.toFormattedTime()
        labelShrouk.text = item.shrouk.toFormattedTime()
        labelZuhr.text = item.zuhr.toFormattedTime()
        labelAsr.text = item.asr.toFormattedTime()
        labelMaghrib.text = item.maghrib.toFormattedTime()
        labelEshaa.text = item.eshaa.toFormattedTime()
        labelMidNight.text = item.midNight?.toFormattedTime()
        labelLastThird.text = item.lastThird?.toFormattedTime()
    }
    
    //MARK: - Actions
    
    
    //MARK: - Helpers
    
}
