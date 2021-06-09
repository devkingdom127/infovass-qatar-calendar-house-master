//
//  QCH.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/16/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation
import Moya

enum QCH {
    case year
    case astronomies
    case allContent
    case settings
    case isThereVacation(_ date: Date)
    case vacations
    case capitals
    case version
    case talas
    case borgs
    case madinah
    case ryiad
    case manama
    case muscat
    case makkah
    case kuwait
    case abudhabi
    case allVersions
    case asset
    case alarms
}

extension QCH: TargetType {
    var baseURL: URL {
        #if DEBUG
        return URL(string: "https://baitaladl.com/tqweem/api/")!
        #else
        return URL(string: "https://baitaladl.com/tqweem/api/")!
        #endif
    }
    
    var assetURL: URL {
        #if DEBUG
        return URL(string: "https://baitaladl.com/tqweem/")!
        #else
        return URL(string: "https://baitaladl.com/tqweem/")!
        #endif
    }
    
    var path: String {
        switch self {
        case .allContent: return "getallcontents"
        case .year: return "getyear"
        case .astronomies: return "getastronomies"
        case .settings: return "getsettings"
        case .isThereVacation(_): return "istherevacation"
        case .vacations: return "getvacations"
        case .capitals: return "getcapitals"
        case .version: return "getversion"
        case .talas: return "gettawalea"
        case .borgs: return "getbrogs"
        case .madinah: return "getalmadinah"
        case .ryiad: return "getryiad"
        case .manama: return "getManama"
        case .muscat: return "getmuscat"
        case .makkah: return "getmakkah"
        case .kuwait: return "getkuwait"
        case .abudhabi: return "getAbudhabi"
        case .allVersions: return "getAllversions"
        case .asset: return ""
        case .alarms: return "getNotifications"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .isThereVacation(let date):
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US")
            formatter.dateFormat = "yyyy-MM-dd"
            return .requestParameters(parameters: ["date": formatter.string(from: date)], encoding: URLEncoding.queryString)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Token": "RanDArArAYNOmNOpjkLSFD"]
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}

extension QCH: MoyaCacheable {
    var cachePolicy: Self.MoyaCacheablePolicy {
        return .returnCacheDataElseLoad
    }
}
