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
    private let group = DispatchGroup()
    
    func fetchUserDataByJson<T>(manager: NetworkManager, _ type: T.Type, handler: @escaping (Result<T, NetworkError>) -> Void) where T: Decodable {
        manager.fetchDataByJson(to: type, handler: handler)
    }
    
    func fetchPlayersImage(handler: @escaping () -> Void) {
        group.enter()
        
        fetchAllMatchData()
        
        group.notify(queue: .global(), execute: handler)
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
        
        fetchImages()
    }
    
    func fetchImages() {
        let players = calculateTopTenUsedPlayer()
        
        players.forEach { playerID in
            let networkModel = NetworkManager(type: .actionImage(id: playerID))
            
            networkModel.fetchDataByImage { [weak self] result in
                switch result {
                case .success(let image):
                    guard let image = image else { return }
                    self?.playerImages.append(image)
                case .failure(_):
                    return
                }
            }
        }
    }
    
    private func calculateTopTenUsedPlayer() -> [Int] {
        let players = playersCounter.sorted { $0.value > $1.value }.map { $0.key }
        
        return players
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
