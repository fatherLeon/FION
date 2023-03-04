//
//  ViewController.swift
//  FIONApp
//
//  Created by 강민수 on 2023/03/05.
//

import UIKit

final class MainViewController: UIViewController {

    @IBOutlet weak var userSearchTextField: UITextField!
    @IBOutlet weak var bestPlayerStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userSearchTextField.clearButtonMode = .always
        self.navigationController?.isNavigationBarHidden = true
    }

    @IBAction func didTapSearchButton(_ sender: UIButton) {
        print("\(self.userSearchTextField.text)")
    }
}

struct ParsingData {
    static func parsePlayerImages() -> [UIImage] {
        return [UIImage()]
    }
    
    static func parsePlayer() -> [Player] {
        return [Player(id: 123, name: "123")]
    }
}

struct URLParsing {
    static func inquirePlayers() -> [Player] {
        let url = APIURLs.playerSpid.url
        
    }
}

struct JSONDecoding<T: Decodable> {
    private init() { }
    
    static func decode(_ type: T.Type, url: URL) -> T? {
        var request = URLRequest(url: url)
        var result: T?
        
        request.httpMethod = "GET"
        request.setValue(<#T##value: String?##String?#>, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            let jsonDecoder = JSONDecoder()
            
            if let data = data {
                do {
                    let jsonData = try jsonDecoder.decode(type, from: data)
                    
                    result = jsonData
                } catch {
                    throw error
                }
            } else {
                throw Error()
            }
        }.resume()
        
        return result
    }
}
