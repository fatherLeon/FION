//
//  Decoder.swift
//  FIONApp
//
//  Created by 강민수 on 2023/04/18.
//

import Foundation

struct Decoder<T> {
    func decodeToJson(by data: Data) -> T? where T: Decodable {
        let decodingData = try? JSONDecoder().decode(T.self, from: data)
        
        return decodingData
    }
}
