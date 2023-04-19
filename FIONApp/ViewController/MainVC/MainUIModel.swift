//
//  MainUIModel.swift
//  FIONApp
//
//  Created by 강민수 on 2023/04/18.
//

import UIKit

final class MainUIModel {
    private let imageGroup = DispatchGroup()
    private let matchGroup = DispatchGroup()
    private let dataGroup = DispatchGroup()
    private var matchDescManager: NetworkManager?
    private var imageManager: NetworkManager?
    
    var ids: [String] = []
    var playersCounter: [Int: Int] = [:]
    var playerImages: [UIImage] = []
    
    func fetchUserDataByJson<T>(manager: NetworkManager, _ type: T.Type, handler: @escaping (Result<T, NetworkError>) -> Void) where T: Decodable {
        manager.fetchDataByJson(to: type, handler: handler)
    }
    
    func fetchPlayerImages(handler: @escaping () -> Void) {
        fetchAllMatchData()
        fetchMatchDescData()
        fetchImages(handler: handler)
    }
    
    private func fetchAllMatchData() {
        let manager = NetworkManager(type: .allMatch())
        matchGroup.enter()
        manager.fetchDataByJson(to: UserMatchObject.self) { [weak self] result in
            switch result {
            case .success(let data):
                self?.ids = data.matchIds
                self?.matchGroup.leave()
            case .failure(_):
                return
            }
        }
        
        matchGroup.wait()
    }
    
    private func fetchMatchDescData() {
        guard let firstId = self.ids.first else { return }
        
        matchDescManager = NetworkManager(type: .match(matchid: firstId))
        
        ids.forEach { id in
            dataGroup.enter()
            matchDescManager?.changeContentType(.match(matchid: id))
            matchDescManager?.fetchDataByJson(to: MatchObject.self) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.addPlayer(data.matchInfo)
                    self?.dataGroup.leave()
                case .failure(_):
                    return
                }
            }
        }
        
        dataGroup.wait()
    }
    
    private func fetchImages(handler: @escaping () -> Void) {
        let playersIds = calculateTopTenUsedPlayer()
        
        guard let firstId = playersIds.first else { return }
        
        imageManager = NetworkManager(type: .actionImage(id: firstId))
        
        playersIds.forEach { id in
            imageGroup.enter()
            imageManager?.changeContentType(.actionImage(id: id))
            
            imageManager?.fetchDataByImage { [weak self] result in
                switch result {
                case .success(let image):
                    self?.imageGroup.leave()
                    guard let image = image else { return }
                    self?.playerImages.append(image)
                case .failure(_):
                    self?.imageGroup.leave()
                }
            }
        }
        
        imageGroup.wait()
        handler()
    }
    
    private func calculateTopTenUsedPlayer() -> [Int] {
        let players = playersCounter.sorted { $0.value > $1.value }.map { $0.key }
        
        return players[0..<10].map { Int($0) }
    }
    
    private func addPlayer(_ matches: [MatchInfo]) {
        matches.forEach { info in
            calculateUsedPlayer(info.player)
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
