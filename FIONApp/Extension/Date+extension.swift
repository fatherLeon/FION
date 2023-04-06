//
//  Date+extension.swift
//  FIONApp
//
//  Created by 강민수 on 2023/04/02.
//

import Foundation

extension Date {
    static let ISOFormatter = {
        let dateFormatter = ISO8601DateFormatter()
        
        return dateFormatter
    }()
    
    static let matchListDateFormatter = {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MM-dd HH:mm"
        
        return dateFormatter
    }()
}
