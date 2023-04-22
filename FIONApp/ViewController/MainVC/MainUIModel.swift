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
    private var allPlayer: [PlayerObject] = []
    private var seasonImage: [Int: UIImage?] = [:]
    private var players: [PlayerModel] = []
    private var topUsedPlayers: [PlayerModel] = []
    
    func fetchUserDataByJson<T>(manager: NetworkManager, _ type: T.Type, handler: @escaping (Result<T, NetworkError>) -> Void) where T: Decodable {
        manager.fetchDataByJson(to: type, handler: handler)
    }
    
    func fetchPlayerImages(handler: @escaping () -> Void) {
        fetchAllSeason()
        fetchAllPlayers()
        fetchAllMatchData()
        fetchMatchDescData()
        fetchPlayerActionImage(handler: handler)
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
                self?.allPlayer = data
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
        matchDescManager = NetworkManager(type: .match(matchid: ""))
        
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
        makeTopUsedPlayer()
    }
    
    private func fetchPlayerActionImage(handler: @escaping () -> Void) {
        imageManager = NetworkManager(type: .actionImage(id: Int.random(in: 1...10)))
        
        self.topUsedPlayers.forEach { player in
            group.enter()
            imageManager?.changeContentType(.actionImage(id: player.id))
            
            imageManager?.fetchDataByImage { [weak self] result in
                switch result {
                case .success(let image):
                    self?.group.leave()
                    guard let image = image,
                          let name = self?.allPlayer.filter({ $0.id == player.id }).first?.name,
                          let index = self?.players.firstIndex(where: { $0.id == player.id }) else { return }
                    
                    self?.players[index].image = image
                    self?.players[index].name = name
                    
                    guard let seasonId = self?.makeSeasonId(player.id),
                          let seasonImage = self?.seasonImage[seasonId] else { return }
                    
                    self?.players[index].seasonImage = seasonImage
                case .failure(_):
                    self?.group.leave()
                }
            }
        }
        
        group.wait()
        handler()
    }
    
    private func makeSeasonId(_ id: Int) -> Int? {
        let startIndex = "\(id)".startIndex
        let endIndex = "\(id)".index(startIndex, offsetBy: 2)
        let seasonIdArr = "\(id)"[startIndex...endIndex]
        
        let seasonId = Int(seasonIdArr)
        
        return seasonId
    }
    
    private func makeTopUsedPlayer() {
        let players = self.players.sorted { $0.count > $1.count }
        
        self.topUsedPlayers = players
    }
    
    private func addPlayer(_ matches: [MatchInfo]) {
        matches.forEach { info in
            calculateUsedPlayer(info.player)
        }
    }
    
    private func calculateUsedPlayer(_ playerArr: [Player]) {
        playerArr.forEach { player in
            guard let index = self.players.firstIndex(where: { $0.id == player.spID }) else {
                self.players.append(PlayerModel(id: player.spID, position: player.spPosition))
                return
            }
            
            self.players[index].updateModel(by: player)
        }
    }
}
