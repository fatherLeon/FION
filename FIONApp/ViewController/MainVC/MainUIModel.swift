//
//  MainUIModel.swift
//  FIONApp
//
//  Created by 강민수 on 2023/04/18.
//

import UIKit

final class MainUIModel {
    private let seasonGroup = DispatchGroup()
    private let playerGroup = DispatchGroup()
    private let imageGroup = DispatchGroup()
    private let matchGroup = DispatchGroup()
    private let dataGroup = DispatchGroup()
    private var matchDescManager: NetworkManager?
    private var imageManager: NetworkManager?
    
    private var matchIds: [String] = []
    private var players: [PlayerObject] = []
    private var seasonCounter: [Int: UIImage?] = [:]
    var playersCounter: [Int: PlayerModel] = [:]
    
    func fetchUserDataByJson<T>(manager: NetworkManager, _ type: T.Type, handler: @escaping (Result<T, NetworkError>) -> Void) where T: Decodable {
        manager.fetchDataByJson(to: type, handler: handler)
    }
    
    func fetchPlayerImages(handler: @escaping () -> Void) {
        fetchAllPlayers()
        fetchAllMatchData()
        fetchMatchDescData()
        fetchImages(handler: handler)
    }
    
    private func fetchAllPlayers() {
        let manager = NetworkManager(type: .allPlayer)
        playerGroup.enter()
        manager.fetchDataByJson(to: [PlayerObject].self) { [weak self] result in
            switch result {
            case .success(let data):
                self?.players = data
                self?.playerGroup.leave()
            case .failure(_):
                return
            }
        }
        
        playerGroup.wait()
    }
    
    private func fetchAllSeason() {
        let manager = NetworkManager(type: .season)
        seasonGroup.enter()
        manager.fetchDataByJson(to: [SeasonObject].self) { [weak self] result in
            switch result {
            case .success(let data):
                self?.fetchSeasonImage(data)
                self?.seasonGroup.leave()
            case .failure(_):
                return
            }
        }
        
        seasonGroup.wait()
    }
    
    private func fetchSeasonImage(_ data: [SeasonObject]) {
        let networkModel = NetworkManager(type: .season)
        data.forEach { season in
            guard let url = URL(string: season.seasonImg),
                  let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else { return }
            
            seasonCounter[season.seasonId] = image
        }
    }
    
    private func fetchAllMatchData() {
        let manager = NetworkManager(type: .allMatch())
        matchGroup.enter()
        manager.fetchDataByJson(to: UserMatchObject.self) { [weak self] result in
            switch result {
            case .success(let data):
                self?.matchIds = data.matchIds
                self?.matchGroup.leave()
            case .failure(_):
                return
            }
        }
        
        matchGroup.wait()
    }
    
    private func fetchMatchDescData() {
        guard let firstId = self.matchIds.first else { return }
        
        matchDescManager = NetworkManager(type: .match(matchid: firstId))
        
        matchIds.forEach { id in
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
                    
                    let name = self?.players.filter { $0.id == id }.first?.name
                    
                    self?.playersCounter[id]?.image = image
                    self?.playersCounter[id]?.name = name
                case .failure(_):
                    self?.imageGroup.leave()
                }
            }
        }
        
        imageGroup.wait()
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
                self.playersCounter[player.spID]?.count += 1
            }
        }
    }
}
