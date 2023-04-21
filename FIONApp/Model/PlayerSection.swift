//
//  PlayerSection.swift
//  FIONApp
//
//  Created by 강민수 on 2023/04/21.
//

enum PlayerSection: CaseIterable {
    case goalkeeper
    case defender
    case midfielder
    case striker
    
    var positionNumber: [Int] {
        switch self {
        case .goalkeeper:
            return [0]
        case .defender:
            return Array(1...8)
        case .midfielder:
            return Array(9...19)
        case .striker:
            return Array(20...27)
        }
    }
}
