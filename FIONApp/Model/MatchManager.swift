//
//  MatchManager.swift
//  FIONApp
//
//  Created by 강민수 on 2023/04/02.
//

import Foundation

struct MatchManager {
    private let matchId: [String]
    private var networkManager: [NetworkManager<MatchObject>] = []
    
    init(matchId: [String]) {
        self.matchId = matchId
        
        matchId.forEach { id in
            let manager = NetworkManager<MatchObject>(type: .match(matchid: id))
            
            networkManager.append(manager)
        }
    }
}
