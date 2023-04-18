//
//  MainUIModel.swift
//  FIONApp
//
//  Created by 강민수 on 2023/04/18.
//

import UIKit

final class MainUIModel {
    private var playersCounter: [Int: Int] = [:]
    private var playerImages: [UIImage] = []
    
    func fetchUserDataByJson<T>(manager: NetworkManager, _ type: T.Type, handler: @escaping (Result<T, NetworkError>) -> Void) where T: Decodable {
        manager.fetchDataByJson(to: type, handler: handler)
    }
    
    func fetchAllMatchData() {
        let manager = NetworkManager(type: .allMatch())
        
        manager.fetchDataByJson(to: UserMatchObject.self) { [weak self] result in
            switch result {
            case .success(let data):
                self?.fetchMatchDescData(data.matchIds)
            case .failure(_):
                return
            }
        }
    }
    
    func fetchMatchDescData(_ ids: [String]) {
        ids.forEach { id in
            let networkModel = NetworkManager(type: .match(matchid: id))
            
            networkModel.fetchDataByJson(to: MatchObject.self) { [weak self] result in
                switch result {
                case .success(let data):
                    let players = data.matchInfo[0].player + data.matchInfo[1].player
                    
                    self?.calculateUsedPlayer(players)
                case .failure(_):
                    return
                }
            }
        }
    }
    
    private func calculateUsedPlayer(_ players: [Player]) {
        players.forEach { player in
            if self.playersCounter[player.spID] == nil {
                self.playersCounter[player.spID] = 1
            } else {
                self.playersCounter[player.spID]? += 1
            }
        }
    }
}
