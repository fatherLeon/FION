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
    var position: Int
    var image: UIImage?
    var seasonImage: UIImage?
    var name: String?
    
    init(position: Int, image: UIImage? = nil) {
        self.position = position
        self.image = image
    }
}
