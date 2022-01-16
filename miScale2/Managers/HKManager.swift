//
//  HKManager.swift
//  miScale2
//
//  Created by Maksym Netreba on 12.10.2021.
//

import HealthKit
import Foundation

class HKManager: ObservableObject {
    private let HKStore = HKHealthStore()
    private var healthAuthStatuses = [HKAuthorizationStatus]()
    
    let bodyMassType = HKQuantityType.quantityType(forIdentifier: .bodyMass)!
    let bmiType = HKQuantityType.quantityType(forIdentifier: .bodyMassIndex)!
    let bfpType = HKQuantityType.quantityType(forIdentifier: .bodyFatPercentage)!
    let lbmType = HKQuantityType.quantityType(forIdentifier: .leanBodyMass)!
    let toothbrushingType = HKCategoryType.categoryType(forIdentifier: .toothbrushingEvent)!
    
    init() {
        let bodyMassAuthStatus = HKStore.authorizationStatus(for: bodyMassType)
        let bmiAuthStatus = HKStore.authorizationStatus(for: bmiType)
        let bfpAuthStatus = HKStore.authorizationStatus(for: bfpType)
        let lbmAuthStatus = HKStore.authorizationStatus(for: lbmType)
        let toothbrushingAuthStatus = HKStore.authorizationStatus(for: toothbrushingType)
        healthAuthStatuses = [bodyMassAuthStatus, bmiAuthStatus, bfpAuthStatus, lbmAuthStatus, toothbrushingAuthStatus]
    }
    
    var isHealthAuthorized: Bool {
        healthAuthStatuses.allSatisfy({$0 == .sharingAuthorized})
    }
    
    func authorizeHealth() {
        // 1. Ensure HealthKit’s Availability on this device
        guard HKHealthStore.isHealthDataAvailable() else {
            fatalError("HealthKit isn't available")
        }

        // 2. Request authorization
        let typesToShare = Set([bodyMassType, bmiType, bfpType, lbmType, toothbrushingType])
        let typesToRead: Set<HKObjectType> = []
        
        HKStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (result, error) in
            if let error = error {
                fatalError("HealthStore request authotization error: \(error)")
            }
            guard result else {
                fatalError("HealthStore request authotization failed. Result: \(result)")
            }
        }
    }
    
    func makeQuantitySample(type: HKQuantityType, unit: HKUnit, value: Double ) -> HKQuantitySample {
        let date = Date()
                
        let quantity = HKQuantity(
            unit: unit,
            doubleValue: value
        )
        
        return HKQuantitySample(
            type: type,
            quantity: quantity,
            start: date,
            end: date
        )
    }
    
    func makeCategorySample(type: HKCategoryType, start: Date, end: Date) -> HKCategorySample {
        HKCategorySample(
            type: type,
            value: HKCategoryValue.notApplicable.rawValue,
            start: start,
            end: end
        )
    }
    
    func save(_ samples: [HKObject], completion: @escaping (Bool, Error?) -> Void) {
        HKStore.save(samples, withCompletion: completion)
    }
    
    func save(_ samples: HKObject, completion: @escaping (Bool, Error?) -> Void) {
        HKStore.save(samples, withCompletion: completion)
    }
}
