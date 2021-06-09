//
//  WidgetContent.swift
//  QatarCalendarHouse
//
//  Created by Moahmmed Sami on 16/04/2021.
//  Copyright © 2021 Infovass. All rights reserved.
//

import WidgetKit

struct WidgetContent: Codable, TimelineEntry {
    var date = Date()
    let dayCalendarDate: String
    let fajr: String
    let shrouk: String
    let zuhr: String
    let asr: String
    let maghrib: String
    let eshaa: String
}
