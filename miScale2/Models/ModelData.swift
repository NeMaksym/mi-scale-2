//
//  ModelData.swift
//  miScale2
//
//  Created by Maksym Netreba on 07.10.2021.
//

import Combine
import Foundation

let WATCH_WEIGHT = 0.05

class ModelData: ObservableObject {
    @Published var scaleMeasurments = ScaleMeasurment(weight: 0, impedance: 0)
    @Published var userProfile: UserProfile {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(userProfile) {
                UserDefaults.standard.set(encoded, forKey: "userProfile")
            }
        }
    }
    
    init() {
        if let userProfile = UserDefaults.standard.data(forKey: "userProfile") {
            let decoder = JSONDecoder()

            if let decodedUserProfile = try? decoder.decode(UserProfile.self, from: userProfile) {
                self.userProfile = decodedUserProfile
                return
            }
        }
        
        self.userProfile = UserProfile(age: 30, height: 180, sex: .male, subtractWatch: true)
    }
    
    var weight: Double {
        if scaleMeasurments.weight >= WATCH_WEIGHT && userProfile.subtractWatch {
            return scaleMeasurments.weight - WATCH_WEIGHT
        } else {
            return scaleMeasurments.weight
        }
    }
    
    private func checkValueOverflow<T: Comparable>(_ value: T,_ min: T,_ max: T) -> T {
        if value < min {
            return min
        } else if value > max {
            return max
        } else {
            return value
        }
    }
    
    // LBM (Lean Body Mass) coefficient
    private var lbmCoefficient: Double {
        var lbm = (userProfile.height * 9.058 / 100) * (userProfile.height / 100)
        lbm += weight * 0.32 + 12.226
        lbm -= scaleMeasurments.impedance * 0.0068
        lbm -= userProfile.age * 0.0542
        return lbm
    }
        
    // BMI (Body Mass Index)
    var bmi: Double {
        if weight == 0 {return 0}
        
        let bmi = weight / ((userProfile.height / 100) * (userProfile.height / 100))
        return checkValueOverflow(bmi, 10, 90)
    }
    
    // BFP (Body Fat Percentage)
    var bfp: Double {
        if weight == 0 {return 0}

        var const: Double

        if userProfile.sex == .female && userProfile.age <= 49 {
            const = 9.25
        } else if userProfile.sex == .female &&  userProfile.age > 49 {
            const = 7.25
        } else {
            const = 0.8
        }

        var coefficient: Double

        if userProfile.sex == .male && weight < 60 {
            coefficient = 0.98
        } else if userProfile.sex == .male && weight > 60 {
            coefficient = 0.96
            if userProfile.height > 160 {
                coefficient *= 1.03
            }
        } else if userProfile.sex == .female && weight < 50 {
            coefficient = 1.02
            if userProfile.height > 160 {
                coefficient *= 1.03
            }
        } else {
            coefficient = 1.0
        }

        var fatPercentage = (1.0 - (((lbmCoefficient - const) * coefficient) / weight)) * 100

        if fatPercentage > 63 {
            fatPercentage = 75
        }

        return self.checkValueOverflow(fatPercentage, 5, 75)
    }
    
    // LBM (Lean Body Mass)
    var lbm: Double {
        let fat = weight / 100 * bfp
        return weight - fat
    }
    
    // MARK: - Codable
    
    enum CodingKeys: CodingKey {
        case userProfile
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(userProfile, forKey: .userProfile)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        userProfile = try container.decode(UserProfile.self, forKey: .userProfile)
    }
}
