//
//  MainUIModel.swift
//  FIONApp
//
//  Created by 강민수 on 2023/04/18.
//

import UIKit

final class MainUIModel {
    private let group = DispatchGroup()
    private var matchDescManager: NetworkManager?
    private var imageManager: NetworkManager?
    
    private var matchIds: [String] = []
    private var players: [PlayerObject] = []
    private var seasonImage: [Int: UIImage?] = [:]
    var playersCounter: [Int: PlayerModel] = [:]
    
    func fetchUserDataByJson<T>(manager: NetworkManager, _ type: T.Type, handler: @escaping (Result<T, NetworkError>) -> Void) where T: Decodable {
        manager.fetchDataByJson(to: type, handler: handler)
    }
    
    func fetchPlayerImages(handler: @escaping () -> Void) {
        fetchAllSeason()
        fetchAllPlayers()
        fetchAllMatchData()
        fetchMatchDescData()
        fetchImages(handler: handler)
    }
    
    private func fetchAllSeason() {
        let manager = NetworkManager(type: .season)
        group.enter()
        manager.fetchDataByJson(to: [SeasonObject].self) { [weak self] result in
            switch result {
            case .success(let data):
                self?.fetchSeasonImage(data)
                self?.group.leave()
            case .failure(_):
                return
            }
        }
        
        group.wait()
    }
    
    private func fetchSeasonImage(_ data: [SeasonObject]) {
        var networkModel = NetworkManager(type: .url(url: ""))
        
        data.forEach { season in
            networkModel.changeContentType(.url(url: season.seasonImg))
            networkModel.fetchDataByImage { [weak self] result in
                switch result {
                case .success(let image):
                    self?.seasonImage[season.seasonId] = image
                case .failure(_):
                    return
                }
            }
        }
    }
    
    private func fetchAllPlayers() {
        let manager = NetworkManager(type: .allPlayer)
        group.enter()
        manager.fetchDataByJson(to: [PlayerObject].self) { [weak self] result in
            switch result {
            case .success(let data):
                self?.players = data
                self?.group.leave()
            case .failure(_):
                return
            }
        }
        
        group.wait()
    }
    
    private func fetchAllMatchData() {
        let manager = NetworkManager(type: .allMatch())
        group.enter()
        manager.fetchDataByJson(to: UserMatchObject.self) { [weak self] result in
            switch result {
            case .success(let data):
                self?.matchIds = data.matchIds
                self?.group.leave()
            case .failure(_):
                return
            }
        }
        
        group.wait()
    }
    
    private func fetchMatchDescData() {
        guard let firstId = self.matchIds.first else { return }
        
        matchDescManager = NetworkManager(type: .match(matchid: firstId))
        
        matchIds.forEach { id in
            group.enter()
            matchDescManager?.changeContentType(.match(matchid: id))
            matchDescManager?.fetchDataByJson(to: MatchObject.self) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.addPlayer(data.matchInfo)
                    self?.group.leave()
                case .failure(_):
                    return
                }
            }
        }
        
        group.wait()
    }
    
    private func fetchImages(handler: @escaping () -> Void) {
        let playersIds = calculateTopTenUsedPlayer()
        
        guard let firstId = playersIds.first else { return }
        
        imageManager = NetworkManager(type: .actionImage(id: firstId))
        
        playersIds.forEach { id in
            group.enter()
            imageManager?.changeContentType(.actionImage(id: id))
            
            imageManager?.fetchDataByImage { [weak self] result in
                switch result {
                case .success(let image):
                    self?.group.leave()
                    guard let image = image else { return }
                    
                    let name = self?.players.filter { $0.id == id }.first?.name
                    
                    self?.playersCounter[id]?.image = image
                    self?.playersCounter[id]?.name = name
                    
                    let startIndex = "\(id)".startIndex
                    let endIndex = "\(id)".index(startIndex, offsetBy: 2)
                    let seasonId = "\(id)"[startIndex...endIndex]
                    
                    guard let key = Int(seasonId),
                          let seasonImage = self?.seasonImage[key] else { return }
                    
                    self?.playersCounter[id]?.seasonImage = seasonImage
                case .failure(_):
                    self?.group.leave()
                }
            }
        }
        
        group.wait()
        handler()
    }
    
    private func calculateTopTenUsedPlayer() -> [Int] {
        let players = playersCounter.sorted { $0.value.count > $1.value.count }.map { $0.key }
        
        return players[0..<100].map { Int($0) }
    }
    
    private func addPlayer(_ matches: [MatchInfo]) {
        matches.forEach { info in
            calculateUsedPlayer(info.player)
        }
    }
    
    private func calculateUsedPlayer(_ players: [Player]) {
        players.forEach { player in
            if self.playersCounter[player.spID] == nil {
                self.playersCounter[player.spID] = PlayerModel(position: player.spPosition)
            } else {
                self.playersCounter[player.spID]?.updateModel(by: player)
            }
        }
    }
}
