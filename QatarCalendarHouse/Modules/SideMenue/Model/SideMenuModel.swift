//
//  SideMenuModel.swift
//  OffaratMasr
//
//  Created by Amr Salman on 12/31/19.
//  Copyright © 2019 Infovass. All rights reserved.
//

import Foundation

class SideMenuModel {
    
    //MARK: - Properties
    let items = [
        SideMenuItem(title: "الصفحة الرئيسية", icon: R.image.main_page()!, isAccessable: true),
        SideMenuItem(title: "موافقات التواريخ", icon: R.image.history_approvals()!, isAccessable: true),
        SideMenuItem(title: "البروج والطوالع وسهيل", icon: R.image.horoscopes()!, isAccessable: true),
        SideMenuItem(title: "التقويم الدائم", icon: R.image.annual_calendar()!, isAccessable: true),
        SideMenuItem(title: "الاجازات الرسمية", icon: R.image.official_holidays()!, isAccessable: true),
        SideMenuItem(title: "مواقيت عواصم الخليج", icon: R.image.pray_time()!, isAccessable: true),
        SideMenuItem(title: "اصدارات دار التقويم القطري", icon: R.image.calender_products()!, isAccessable: true),
        SideMenuItem(title: "اتجاه القبلة", icon: R.image.qebla()!, isAccessable: true),
        SideMenuItem(title: "امساكية رمضان", icon: R.image.calender()!, isAccessable: true),
        SideMenuItem(title: "الإعدادات", icon: R.image.settings_red()!, isAccessable: true),
        SideMenuItem(title: "نبذة عن دار التقويم القطري", icon: R.image.about_us()!, isAccessable: true),
        SideMenuItem(title: "تواصل معنا", icon: R.image.contact_us()!, isAccessable: true),
    ]

    //MARK: - Initializers
        
    //MARK: - API requests
    
    //MARK: - Helpers
    
}
