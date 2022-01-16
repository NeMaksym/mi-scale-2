//
//  UserProfile.swift
//  miScale2
//
//  Created by Maksym Netreba on 11.10.2021.
//

import Foundation

struct UserProfile: Codable {
    var age: Double
    var height: Double
    var sex: SexType
    var subtractWatch: Bool
    
    enum SexType: String, CaseIterable, Identifiable, Codable {
        case male
        case female
        
        var id: String { self.rawValue }
    }
}
