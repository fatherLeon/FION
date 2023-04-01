//
//  ModelManager.swift
//  FIONApp
//
//  Created by 강민수 on 2023/04/01.
//

import Foundation

final class ModelManager<T> {
    private let networkManager: NetworkManager
    
    init(session: URLSession = .shared) {
        self.networkManager = NetworkManager(session: session)
    }
    
    
}
