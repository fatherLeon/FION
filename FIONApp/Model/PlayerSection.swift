//
//  PlayerSection.swift
//  FIONApp
//
//  Created by 강민수 on 2023/04/21.
//

enum PlayerSection: Int, CaseIterable {
    case goalkeeper = 0
    case centerback
    case sideback
    case midfielder
    case winger
    case striker
    
    var positionNumber: [Int] {
        switch self {
        case .goalkeeper:
            return [0]
        case .centerback:
            return [1, 4, 5, 6]
        case .sideback:
            return [2, 3, 7, 8]
        case .midfielder:
            return [9, 10, 11, 13, 14, 15, 17, 18, 19]
        case .winger:
            return [12, 16, 23, 27]
        case .striker:
            return [20, 21, 22, 24, 25, 26]
        }
    }
    
    var positionDescription: String {
        switch self {
        case .goalkeeper:
            return "골키퍼(GK)"
        case .centerback:
            return "센터백(SW, RCB, CB, LCB)"
        case .sideback:
            return "풀백, 윙백(RWB, RB, LB, LWB)"
        case .midfielder:
            return "미드필더"
        case .winger:
            return "윙어(RM, LM, RW, LW)"
        case .striker:
            return "공격수(RF, CF, LF, RS, ST, LS)"
        }
    }
}
