//
//  PlayerModel.swift
//  FIONApp
//
//  Created by 강민수 on 2023/04/21.
//

import UIKit

struct PlayerModel: Hashable {
    let id = UUID()
    var count = 1
    var position: [Int: Int] = [:]
    var image: UIImage?
    var seasonImage: UIImage?
    var name: String?
    
    init(position: Int) {
        self.position[position] = 1
    }
    
    var mostUsedPosition: Int {
        guard let positionNumber = position.sorted(by: { $0.value > $1.value }).first else { return 100 }
        
        return positionNumber.key
    }
    
    mutating func updateModel(by player: Player) {
        self.count += 1
        if position[player.spPosition] == nil {
            position[player.spPosition] = 1
        } else {
            position[player.spPosition]? += 1
        }
    }
}
