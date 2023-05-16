//
//  MatchesUIModel.swift
//  FIONApp
//
//  Created by 강민수 on 2023/04/02.
//

import Foundation

final class MatchesUIModel {
    private let group = DispatchGroup()
    private var matchIDs: [String] = []
    private var matchesInfo: [MatchObject] = []
    private var networkManager: NetworkManager?
    
    func fetchUserMatches(_ userID: String, completion: @escaping (Result<[MatchObject], Error>) -> Void) {
        networkManager = NetworkManager(type: .userMatch(id: userID, matchType: 50, limit: 20))
        
        networkManager?.fetchDataByJson(to: UserMatchObject.self) { [weak self] result in
            switch result {
            case .success(let matchObject):
                self?.matchIDs = matchObject.matchIds
                self?.fetchMatchInfo(completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func fetchMatchInfo(completion: @escaping (Result<[MatchObject], Error>) -> Void) {
        matchIDs.forEach { matchID in
            self.networkManager?.changeContentType(.match(matchid: matchID))
            group.enter()
            self.networkManager?.fetchDataByJson(to: MatchObject.self) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.matchesInfo.append(data)
                case .failure(let error):
                    completion(.failure(error))
                }
                self?.group.leave()
            }
        }
        
        group.notify(queue: .global()) {
            self.matchesInfo.sort { $0.matchDate > $1.matchDate }
            completion(.success(self.matchesInfo))
        }
    }
}
