//
//  VacationsModel.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/26/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation
import PromiseKit

class VacationsModel {
    
    //MARK: - Properties
    
    private lazy var remoteAPI: QCHRemoteAPI = {
        let remote = QCHRemoteAPIImpl()
        return remote
    }()

    private lazy var vacationRepo: VacationRepository = {
        let repo = QCHVacationRepository(remoteAPI: remoteAPI)
        return repo
    }()
    
    private lazy var allContentRepo: AllContentRepository = {
        let repo = QCHAllContentRepository(remoteAPI: remoteAPI)
        return repo
    }()
        
    //MARK: - Initializers
            
    //MARK: - Helpers
    
    func requestVacations() -> Promise<[Vacation]> {
        return vacationRepo.getVacations()
    }

    func requestSchoolCalendar() -> Promise<ContentItem> {
        return allContentRepo.getAllContent().filterValues {
            guard let type = $0.type else { return false }
            return type == .schoolCalndar
        }.firstValue
    }
}
