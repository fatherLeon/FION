//
//  CustomError.swift
//  FIONApp
//
//  Created by 강민수 on 2023/03/21.
//

import Foundation

enum NetworkError: LocalizedError, Equatable {
    case invalidURL
    case networkError
    case responseError(Int)
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL이 올바르지 않습니다"
        case .networkError:
            return "네트워크 오류가 있습니다"
        case .responseError(let statusCode):
            return """
                    HTTPURLResponse : \(statusCode)
                    response가 실패했습니다
                    """
        case .decodingError:
            return "decoding이 실패했습니다"
        }
    }
}
