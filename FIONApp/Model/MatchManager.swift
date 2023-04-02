//
//  MatchManager.swift
//  FIONApp
//
//  Created by 강민수 on 2023/04/02.
//

import Foundation

class MatchManager {
    private let matchId: [String]
    private var networkManagers: [NetworkManager<MatchObject>] = []
    var matchesInfo: [MatchObject] = []
    
    init(matchIds: [String]) {
        self.matchId = matchIds
        
        matchIds.forEach { id in
            let manager = NetworkManager<MatchObject>(type: .match(matchid: id))
            
            networkManagers.append(manager)
        }
    }
    
    func fetchMatchInfo() {
        networkManagers.forEach { manager in
            manager.fetchDataByJson { [weak self] result in
                switch result {
                case .success(let data):
                    self?.matchesInfo.append(data)
                    NotificationCenter.default.post(name: .matchesInfo, object: nil)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
