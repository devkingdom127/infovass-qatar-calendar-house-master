//
//  ApplicationContentModel.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 4/18/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation
import PromiseKit

class ApplicationContentModel {
    
    // MARK: - Properties
    
    private lazy var remoteAPI: QCHRemoteAPI = {
        let remote = QCHRemoteAPIImpl()
        return remote
    }()
    
    private lazy var refresher: NotificationRefresher = {
        let refresher = NotificationsModel()
        return refresher
    }()
    
    private lazy var dailyCalendarRepo: DailyCalendarRepository = {
        let repo = QCHDailyCalendarRepository(remoteAPI: remoteAPI, notificationRefresher: refresher)
        return repo
    }()

    private lazy var borgAndTalaAndSuhailRepo: BorgAndTalaAndSuhailRepository = {
        let repo = QCHBorgAndTalaAndSuhailRepository(remoteAPI: remoteAPI)
        return repo
    }()
    
    private lazy var allContentRepo: AllContentRepository = {
        let repo = QCHAllContentRepository(remoteAPI: remoteAPI)
        return repo
    }()

    private lazy var vacationRepo: VacationRepository = {
        let repo = QCHVacationRepository(remoteAPI: remoteAPI)
        return repo
    }()

    private lazy var capitalsRepo: PrayTimesRepository = {
        let repo = QCHPrayTimesRepository(remoteAPI: remoteAPI)
        return repo
    }()

    private lazy var settingsRepo: SettingsRepository = {
        let repo = QCHSettingsRepository(remoteAPI: remoteAPI)
        return repo
    }()
    
    private lazy var astronomiesRepo: AstronomiesRepository = {
        let repo = QCHAstronomiesRepository(remoteAPI: remoteAPI)
        return repo
    }()

    
    // MARK: - Initializers
    
    init() {
        
    }
    
    // MARK: - Helpers
    
    func configure() -> Promise<Void> {
        return Promise { seal in
            firstly {
                self.remoteAPI.getAllVersions()
            }.compactMap {
                $0.list
            }.then {
                self.changesInTables($0)
            }.then {
                self.transformIntoPromises($0)
            }.then {
                when(fulfilled: $0)
            }.done {
                seal.fulfill($0)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload-home"), object: nil)
            }.catch {
                seal.reject($0)
            }
        }
    }
    
    private func changesInTables(_ newVersions: [TableVersion]) -> Promise<[Table]> {
        return Promise { seal in
            var tables = [Table]()
            for table in newVersions {
                guard let tableType = table.table else { continue }
                if UserDefaults.standard.offlineTablesVersion[table.tableName] != String(table.version) {
                    tables.append(tableType)
                }
            }
            seal.fulfill(tables)
        }
    }
    
    private func transformIntoPromises(_ tables: [Table]) -> Promise<[Promise<Void>]> {
        return Promise { mainSeal in
            var promises = [Promise<Void>]()
            if tables.isEmpty {
                mainSeal.fulfill(promises)
            }
            for table in tables {
                switch table {
                case .years:
                    promises.append(Promise { seal in
                        dailyCalendarRepo
                            .getDailyCalendar(forceReload: true)
                            .done { _ in seal.fulfill(())
                                if promises.filter({ $0.isPending }).isEmpty {
                                    mainSeal.fulfill(promises)
                                }
                            }
                            .catch { seal.reject($0) }
                    })
                case .abudhabi:
                    promises.append(Promise { seal in
                        capitalsRepo
                            .getAbudhabi(forceReload: true)
                            .done { _ in seal.fulfill(())
                                if promises.filter({ $0.isPending }).isEmpty {
                                    mainSeal.fulfill(promises)
                                }
                            }
                            .catch { seal.reject($0) }
                    })
                case .kuwait:
                    promises.append(Promise { seal in
                        capitalsRepo
                            .getKuwait(forceReload: true)
                            .done { _ in seal.fulfill(())
                                if promises.filter({ $0.isPending }).isEmpty {
                                    mainSeal.fulfill(promises)
                                }
                            }
                            .catch { seal.reject($0) }
                    })
                case .manama:
                    promises.append(Promise { seal in
                        capitalsRepo
                            .getManama(forceReload: true)
                            .done { _ in seal.fulfill(())
                                if promises.filter({ $0.isPending }).isEmpty {
                                    mainSeal.fulfill(promises)
                                }
                            }
                            .catch { seal.reject($0) }
                    })
                case .muscat:
                    promises.append(Promise { seal in
                        capitalsRepo
                            .getMuscat(forceReload: true)
                            .done { _ in seal.fulfill(())
                                if promises.filter({ $0.isPending }).isEmpty {
                                    mainSeal.fulfill(promises)
                                }
                            }
                            .catch { seal.reject($0) }
                    })
                case .makkah:
                    promises.append(Promise { seal in
                        capitalsRepo
                            .getMakkah(forceReload: true)
                            .done { _ in seal.fulfill(())
                                if promises.filter({ $0.isPending }).isEmpty {
                                    mainSeal.fulfill(promises)
                                }
                            }
                            .catch { seal.reject($0) }
                    })
                case .almadinah:
                    promises.append(Promise { seal in
                        capitalsRepo
                            .getAlmadinah(forceReload: true)
                            .done { _ in seal.fulfill(())
                                if promises.filter({ $0.isPending }).isEmpty {
                                    mainSeal.fulfill(promises)
                                }
                            }
                            .catch { seal.reject($0) }
                    })
                case .ryaid:
                    promises.append(Promise { seal in
                        capitalsRepo
                            .getRyiad(forceReload: true)
                            .done { _ in seal.fulfill(())
                                if promises.filter({ $0.isPending }).isEmpty {
                                    mainSeal.fulfill(promises)
                                }
                            }
                            .catch { seal.reject($0) }
                    })
                case .borgTaleas:
                    promises.append(Promise { seal in
                        when(fulfilled: borgAndTalaAndSuhailRepo.getBorgs(forceReload: true), borgAndTalaAndSuhailRepo.getTalas(forceReload: true))
                            .done { _ in seal.fulfill(())
                                if promises.filter({ $0.isPending }).isEmpty {
                                    mainSeal.fulfill(promises)
                                }
                            }
                            .catch { seal.reject($0) }
                    })
                case .astronomies:
                    promises.append(Promise { seal in
                        astronomiesRepo
                            .getAstronomies(forceReload: true)
                            .done { _ in seal.fulfill(())
                                if promises.filter({ $0.isPending }).isEmpty {
                                    mainSeal.fulfill(promises)
                                }
                            }
                            .catch { seal.reject($0) }
                    })
                case .contents:
                    promises.append(Promise { seal in
                        allContentRepo
                            .getAllContent(forceReload: true)
                            .done { _ in seal.fulfill(())
                                if promises.filter({ $0.isPending }).isEmpty {
                                    mainSeal.fulfill(promises)
                                }
                            }
                            .catch { seal.reject($0) }
                    })
                case .settings:
                    promises.append(Promise { seal in
                        settingsRepo
                            .getSettings(forceReload: true)
                            .done { _ in seal.fulfill(())
                                if promises.filter({ $0.isPending }).isEmpty {
                                    mainSeal.fulfill(promises)
                                }
                            }
                            .catch { seal.reject($0) }
                    })
                case .vacations:
                    promises.append(Promise { seal in
                        vacationRepo
                            .getVacations(forceReload: true)
                            .done { _ in seal.fulfill(())
                                if promises.filter({ $0.isPending }).isEmpty {
                                    mainSeal.fulfill(promises)
                                }
                            }
                            .catch { seal.reject($0) }
                    })
                case .capitals:
                    promises.append(Promise { seal in
                        capitalsRepo
                            .getCapitals(forceReload: true)
                            .done { _ in seal.fulfill(())
                                if promises.filter({ $0.isPending }).isEmpty {
                                    mainSeal.fulfill(promises)
                                }
                            }
                            .catch { seal.reject($0) }
                    })
                case .borg, .tala:
                    continue
                }
            }

        }
    }
    
}
