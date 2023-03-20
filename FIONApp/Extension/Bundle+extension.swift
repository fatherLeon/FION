//
//  Bundle+extension.swift
//  FIONApp
//
//  Created by 강민수 on 2023/03/20.
//

import UIKit

extension Bundle {
    var apiKey: String {
        guard let file = self.path(forResource: "APIKey", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file) else { return "" }
        
        guard let key = resource["APIKey"] as? String else { fatalError("API Key를 입력해주세요") }
        
        return key
    }
    
    var logo: UIImage? {
        guard let assetData = NSDataAsset(name: "FIFALogo", bundle: .main),
              let logoImage = UIImage(data: assetData.data) else { return nil }
        
        return logoImage
    }
}
