//
//  ModelManager.swift
//  FIONApp
//
//  Created by 강민수 on 2023/04/01.
//

import Foundation

final class ModelManager<T> {
    private let type: ContentType
    private let networkManager: NetworkManager
    
    init(session: URLSession = .shared, type: ContentType) {
        self.networkManager = NetworkManager(session: session)
        self.type = type
    }
    
    func fetchData(handler: @escaping (Result<T, NetworkError>) -> Void) {
    }
}
