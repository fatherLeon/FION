//
//  URLSessionProtocol.swift
//  FIONApp
//
//  Created by 강민수 on 2023/04/17.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask?
}
