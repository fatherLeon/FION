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
    
    mutating func updateModel(by player: Player) {
        if position[player.spPosition] == nil {
            position[player.spPosition] = 1
        } else {
            position[player.spPosition]? += 1
        }
    }
}
