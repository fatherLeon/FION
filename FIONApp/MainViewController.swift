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
    
    let imageID = ["101000001", "101000241", "101001625", "101190045", "201000570", "201003647", "201052241", "201150565"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userSearchTextField.clearButtonMode = .always
        self.navigationController?.isNavigationBarHidden = true
        
        getRandomImage()
    }

    @IBAction func didTapSearchButton(_ sender: UIButton) {
    }
    
    func addPlayerImageInStackView(image: UIImage) {
        let imageView = UIImageView(image: image)
        
        self.bestPlayerStackView.addArrangedSubview(imageView)
    }
    
    func getRandomImage() {
        
        for id in imageID {
            let url = URL(string: "https://fo4.dn.nexoncdn.co.kr/live/externalAssets/common/playersAction/p\(id).png")!
            var request = URLRequest(url: url)
            
            request.httpMethod = "GET"
            request.setValue(Bundle.main.apiKey, forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                guard let data = data else { return }
                
                if let data = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self!.addPlayerImageInStackView(image: data)
                    }
                }
            }.resume()
        }
    }
}

struct URLParsing {
    static func inquirePlayers() -> [Player]? {
        let url = APIURLs.playerSpid.url
        
        return APIRequest.decode([Player].self, url: url)
    }
}

struct APIRequest<T: Decodable> {
    private init() { }

    static func decode(_ type: T.Type, url: URL) -> T? {
        var request = URLRequest(url: url)
        var result: T?

        request.httpMethod = "GET"
        request.setValue(Bundle.main.apiKey, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            
            do {
                let jsonData = try JSONDecoder().decode(type, from: data)
                
                result = jsonData
            } catch {
                print(error)
            }
        }.resume()
        
        return result
    }
}
