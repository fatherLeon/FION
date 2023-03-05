//
//  Bundle.swift
//  FIONApp
//
//  Created by 강민수 on 2023/03/05.
//

import Foundation

extension Bundle {
    var apiKey: String {
        guard let url = Bundle.main.url(forResource: "APIKey", withExtension: "plist") else { return "" }
        
        do {
            let data = try Data(contentsOf: url)
            guard let plistData = try PropertyListSerialization.propertyList(from: data, format: nil) as? [String: String], let key = plistData["APIKey"] else { return "" }
            
            return key
        } catch {
            return ""
        }
    }
}
