//
//  Date+extension.swift
//  FIONApp
//
//  Created by 강민수 on 2023/04/02.
//

import Foundation

extension Date {
    static let matchDateFormatter = {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter
    }
}
