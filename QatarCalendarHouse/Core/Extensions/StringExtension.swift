//
//  StringExtension.swift
//  MyCommunity
//
//  Created by Amr Salman on 10/3/18.
//  Copyright © 2018 Amr Salman. All rights reserved.
//

import UIKit

extension String {
    enum Key: String, CaseIterable {
        case dailyCalendar
        case content
        case tala
        case borg
        case astronomies
        case settings
        case vacations
        case capitals
        case abudhabi, kuwait, manama, muscat, makkah, almadinah, ryaid
    }
    
    func toFormattedTime(twelveFormat: Bool = true) -> String? {
        let fromFormatter = DateFormatter()
        fromFormatter.locale = Locale.init(identifier: "en_US")
        fromFormatter.timeZone = TimeZone(secondsFromGMT: 3*60*60)
        fromFormatter.dateFormat = "HH:mm:ss"
        guard let date = fromFormatter.date(from: self) else { return nil }
        
        let toFormatter = DateFormatter()
        toFormatter.locale = Locale.init(identifier: "en_US")
        toFormatter.timeZone = TimeZone(secondsFromGMT: 3*60*60)
        toFormatter.dateFormat = "hh:mm"
        return toFormatter.string(from: date)
    }
    
    var timeAgo: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: self) {
            let calendar = Calendar.current
            let now = Date()
            let earliest = (now as NSDate).earlierDate(date)
            let latest = (earliest == now) ? date : now
            let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
            
            if (components.year! >= 2) {
                return "منذ \(components.year!) سنين"
            } else if (components.year! >= 1){
                return "العام الماضي"
            } else if (components.month! >= 2) {
                return "منذ \(components.month!) شهور"
            } else if (components.month! >= 1){
                return "الشهر الماضي"
            } else if (components.weekOfYear! >= 2) {
                return "منذ \(components.weekOfYear!) أسبوع"
            } else if (components.weekOfYear! >= 1){
                return "الاسبوع الماضي"
            } else if (components.day! >= 2) {
                return "منذ \(components.day!) أيام"
            } else if (components.day! >= 1){
                return "بالأمس"
            } else if (components.hour! >= 2) {
                return "منذ \(components.hour!) ساعات"
            } else if (components.hour! >= 1){
                return "منذ ساعة"
            } else if (components.minute! >= 2) {
                return "منذ \(components.minute!) دقائق"
            } else if (components.minute! >= 1){
                return "منذ دقيقة"
            } else if (components.second! >= 3) {
                return "منذ \(components.second!) ثوان"
            } else {
                return "الأن"
            }
        }

        return ""
    }
    
    var localizedString: String {
        return NSLocalizedString(self, comment: "")
    }
    
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var removedSpaces: String? {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    var underlined: NSAttributedString? {
        return underlined(withColor: .white)
    }
    
    func underlined(withColor color : UIColor) -> NSAttributedString? {
        let color = color
        
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single, NSAttributedString.Key.foregroundColor: color] as [NSAttributedString.Key : Any]
        let attributedString = NSAttributedString(string: self, attributes: underlineAttribute)
        return attributedString
    }
    
    func formatLocalizedString(withValue newValue: String) -> String{
        return self.replacingOccurrences(of: "{0}", with: newValue)
    }
    
    func formatLocalizedString(firstValue firstStr: String, secondValue secondStr: String) -> String {
        var formattedString = self.replacingOccurrences(of: "{0}", with: firstStr)
        formattedString = formattedString.replacingOccurrences(of: "{1}", with: secondStr)
        return formattedString
    }
    
    ///
    
    /// Calculates string width based on max height and font
    ///
    /// - Parameters:
    ///   - height: max height
    ///   - font: font used
    /// - Returns: text width
    func widthWithConstrainedHeight(height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.width
    }
    
    
    /// Calculates string height based on max width and font
    ///
    /// - Parameters:
    ///   - width: max width
    ///   - font: font uesd
    /// - Returns: text hight
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
    
    func getFullDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSxxx"
        let dateObject = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.dateStyle = .medium
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        if dateObject != nil {
            let date = dateFormatter.string(from: dateObject!)
            return date
        } else {
            return " "
        }
    }
    
    func formattedDate(with format:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSxxx"
        let dateObject = dateFormatter.date(from: self)
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        if dateObject != nil {
            let date = dateFormatter.string(from: dateObject!)
            return date
        } else {
            return " "
        }
    }
    
    func multipleFontString(withUniqueText unique: String, uiniqueFont uniqueFont: UIFont, andNormalFont normalFont: UIFont) -> NSAttributedString {
        let string = NSString(string: self)
        let differentRange = string.range(of: unique)
        if differentRange.location != NSNotFound {
            let allAttr = [NSAttributedString.Key.font: normalFont]
            let vodafoneAttr = [NSAttributedString.Key.font: uniqueFont]
            
            let attributedText = NSMutableAttributedString(string: self, attributes: allAttr)
            attributedText.addAttributes(vodafoneAttr, range: differentRange)
            
            return attributedText
        }
        return NSAttributedString()
    }
    
    //: ### Base64 encoding a string
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    //: ### Base64 decoding a string
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    func validatePhoneNumber() -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: self)
        return result
    }
        
    func deCodeImage () -> UIImage? {
        if let decodedData = Data(base64Encoded: self, options: .ignoreUnknownCharacters) {
            let image = UIImage(data: decodedData)
            return image
        }
        
        return nil
    }
    
    func withStrik() -> NSMutableAttributedString {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
    
//    func localized() -> String {
//        guard let path = Bundle.main.path(forResource: Language.current.rawValue, ofType: "lproj") else { return self }
//        let bundle = Bundle(path: path)
//
//        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
//    }
    
    func stringByAddingPercentEncodingForFormUrlencoded() -> String? {
        let characterSet = NSMutableCharacterSet.alphanumeric()
        characterSet.addCharacters(in: "-._* ")
        
        return addingPercentEncoding(withAllowedCharacters: characterSet as CharacterSet)?.replacingOccurrences(of: " ", with: "+")
    }
    
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
    
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "dd-MM-yyyy"
        guard let date = formatter.date(from: self) else {
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.date(from: self)
        }
        return date
    }
        
    func toPrayDate() -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss ZZZZ"
        return formatter.date(from: self)
    }
    
    func toAlarmDate() -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: self)
    }

    func toEnglishNumbers() -> String {
        let arabicNumbers = ["٠": "0","١": "1","٢": "2","٣": "3","٤": "4","٥": "5","٦": "6","٧": "7","٨": "8","٩": "9"]
        var txt = self
        _ = arabicNumbers.map { txt = txt.replacingOccurrences(of: $0, with: $1)}
        return txt
    }
}
