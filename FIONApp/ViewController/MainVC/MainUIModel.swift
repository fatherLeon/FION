//
//  MainUIModel.swift
//  FIONApp
//
//  Created by 강민수 on 2023/04/18.
//

import UIKit

final class MainUIModel {
    private var manager: NetworkManager?
    private var userData: UserInfoObject?
    private var playerImages: [UIImage] = []
    
    func changeManager(_ manager: NetworkManager) {
        self.manager = manager
    }
    
    func fetchUserDataByJson<T>(manager: NetworkManager, _ type: T.Type, handler: @escaping (Result<T, NetworkError>) -> Void) where T: Decodable {
        manager.fetchDataByJson(to: type, handler: handler)
    }
}
