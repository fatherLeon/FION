//
//  URLSessionProtocol.swift
//  FIONApp
//
//  Created by 강민수 on 2023/04/17.
//

import Foundation

protocol URLSessionProtocol {
    func makeURLSessionDataTask(request: URLRequest, completion: @escaping ((Result<Data, NetworkError>) -> Void)) -> URLSessionDataTask?
}
