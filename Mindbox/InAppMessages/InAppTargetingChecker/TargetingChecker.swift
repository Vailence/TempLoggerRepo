//
//  InternalTargetingChecker.swift
//  Mindbox
//
//  Created by Akylbek Utekeshev on 17.01.2023.
//

import Foundation
import MindboxLogger

protocol TargetingCheckerContextProtocol: AnyObject {
    var context: PreparationContext { get set }
    var checkedSegmentations: [SegmentationCheckResponse.CustomerSegmentation]? { get set }
    var geoModels: InAppGeoResponse? { get set }
}

protocol TargetingCheckerMap: AnyObject {
    var checkerMap: [Targeting: (Targeting) -> CheckerFunctions] { get set }
}

protocol TargetingCheckerActionProtocol: AnyObject {
    func prepare(targeting: Targeting)
    func check(targeting: Targeting) -> Bool
}

struct CheckerFunctions {
    var prepare: (inout PreparationContext) -> Void = {(context: inout PreparationContext) in return }
    var check: () -> Bool = {() in return false }
}

protocol InAppTargetingCheckerProtocol: TargetingCheckerContextProtocol, TargetingCheckerActionProtocol, TargetingCheckerMap { }

final class InAppTargetingChecker: InAppTargetingCheckerProtocol {
    
    init() {
        setupCheckerMap()
    }
    
    var context = PreparationContext()
    var checkedSegmentations: [SegmentationCheckResponse.CustomerSegmentation]? = nil
    var geoModels: InAppGeoResponse?
    
    var checkerMap: [Targeting: (Targeting) -> CheckerFunctions] = [:]
    
    func prepare(targeting: Targeting) {
        guard let target = checkerMap[targeting] else {
            Logger.common(message: "target not exist in checkerMap. Targeting: \(targeting)", level: .error, category: .inAppMessages)
            return
        }
        
        target(targeting).prepare(&context)
    }
    
    func check(targeting: Targeting) -> Bool {
        guard let target = checkerMap[targeting] else {
            Logger.common(message: "target not exist in checkerMap. Targeting: \(targeting)", level: .error, category: .inAppMessages)
            return false
        }
        
        return target(targeting).check()
    }
    
    private func setupCheckerMap() {
        let checkerFunctions = CheckerFunctions()
        checkerMap[.unknown] = { (T) -> CheckerFunctions in
            return checkerFunctions
        }
        
        let trueTargeting = TrueTargeting()
        checkerMap[.true(trueTargeting)] = { (T) -> CheckerFunctions in
            let trueChecker = TrueTargetingChecker()
            switch T {
            case .true(let targeting):
                return CheckerFunctions { context in
                    return trueChecker.prepare(targeting: targeting, context: &context)
                } check: {
                    return trueChecker.check(targeting: targeting)
                }
            default:
                return checkerFunctions
            }
        }
        
        let andTargeting = AndTargeting(nodes: [])
        checkerMap[.and(andTargeting)] = { [weak self] (T) -> CheckerFunctions in
            let andChecker = AndTargetingChecker()
            andChecker.checker = self
            switch T {
            case .and(let targeting):
                return CheckerFunctions { context in
                    return andChecker.prepare(targeting: targeting, context: &context)
                } check: {
                    return andChecker.check(targeting: targeting)
                }
            default:
                return checkerFunctions
            }
        }
        
        let orTargeting = OrTargeting(nodes: [])
        checkerMap[.or(orTargeting)] = { [weak self] (T) -> CheckerFunctions in
            let orChecker = OrTargetingChecker()
            orChecker.checker = self
            switch T {
            case .or(let targeting):
                return CheckerFunctions { context in
                    return orChecker.prepare(targeting: targeting, context: &context)
                } check: {
                    return orChecker.check(targeting: targeting)
                }
            default:
                return checkerFunctions
            }
        }
        
        let segmentTargeting = SegmentTargeting(kind: .negative,
                                                segmentationInternalId: "",
                                                segmentationExternalId: "",
                                                segmentExternalId: "")
        checkerMap[.segment(segmentTargeting)] = { [weak self] (T) -> CheckerFunctions in
            let segmentChecker = SegmentTargetingChecker()
            segmentChecker.checker = self
            switch T {
            case .segment(let targeting):
                return CheckerFunctions { context in
                    return segmentChecker.prepare(targeting: targeting, context: &context)
                } check: {
                    return segmentChecker.check(targeting: targeting)
                }
            default:
                return checkerFunctions
            }
        }
        
        let cityTargeting = CityTargeting(kind: .negative, ids: [])
        checkerMap[.city(cityTargeting)] = { [weak self] (T) -> CheckerFunctions in
            let cityChecker = CityTargetingChecker()
            cityChecker.checker = self
            switch T {
            case .city(let targeting):
                return CheckerFunctions { context in
                    return cityChecker.prepare(targeting: targeting, context: &context)
                } check: {
                    return cityChecker.check(targeting: targeting)
                }
            default:
                return checkerFunctions
            }
        }
        
        let regionTargeting = RegionTargeting(kind: .negative, ids: [])
        checkerMap[.region(regionTargeting)] = { [weak self] (T) -> CheckerFunctions in
            let regionChecker = RegionTargetingChecker()
            regionChecker.checker = self
            switch T {
            case .region(let targeting):
                return CheckerFunctions { context in
                    return regionChecker.prepare(targeting: targeting, context: &context)
                } check: {
                    return regionChecker.check(targeting: targeting)
                }
            default:
                return checkerFunctions
            }
        }
        
        let countryTargeting = CountryTargeting(kind: .negative, ids: [])
        checkerMap[.country(countryTargeting)] = { [weak self] (T) -> CheckerFunctions in
            let countryChecker = CountryTargetingChecker()
            countryChecker.checker = self
            switch T {
            case .country(let targeting):
                return CheckerFunctions { context in
                    return countryChecker.prepare(targeting: targeting, context: &context)
                } check: {
                    return countryChecker.check(targeting: targeting)
                }
            default:
                return checkerFunctions
            }
        }
    }
}
