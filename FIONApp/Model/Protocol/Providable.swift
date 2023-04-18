//
//  Providable.swift
//  FIONApp
//
//  Created by 강민수 on 2023/04/18.
//

import Foundation

protocol Providable {
    func makeRequest(contentType: ContentType) -> URLRequest?
    func makeURLSessionDataTask(request: URLRequest, completion: @escaping ((Result<Data, NetworkError>) -> Void)) -> URLSessionDataTask?
}
