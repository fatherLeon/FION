//
//  ViewController.swift
//  FIONApp
//
//  Created by 강민수 on 2023/03/05.
//

import UIKit

class MainViewController: UIViewController {
    
    private var userNetworkManager: NetworkManager<UserInfoObject>? = nil
    
    private var logoImageView = UIImageView()
    private var userTextField = UITextField()
    private var searchButton = UIButton(type: .roundedRect)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        configureLogoImageView()
        configureUserTextField()
        configureSearchButton()
    }
    
    @objc func didTapSearchButton() {
        guard let nickname = self.userTextField.text else { return }
        
        userNetworkManager = NetworkManager(type: ContentType.userInfo(nickname: nickname))
        
        userNetworkManager?.fetchDataByJson { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    } 
}

// MARK: - UI
extension MainViewController {
    
    private func configureLogoImageView() {
        self.logoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.logoImageView.contentMode = .scaleToFill
        self.logoImageView.image = Bundle.main.logo
        
        self.view.addSubview(self.logoImageView)
        
        NSLayoutConstraint.activate([
            self.logoImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.logoImageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.logoImageView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func configureUserTextField() {
        self.userTextField.delegate = self
        
        self.userTextField.translatesAutoresizingMaskIntoConstraints = false
        self.userTextField.borderStyle = .roundedRect
        self.userTextField.placeholder = "유저 닉네임을 입력해주세요"
        self.userTextField.textColor = .systemGreen
        
        self.view.addSubview(self.userTextField)
        
        NSLayoutConstraint.activate([
            self.userTextField.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor, constant: 10),
            self.userTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10)
        ])
    }
    
    private func configureSearchButton() {
        self.searchButton.translatesAutoresizingMaskIntoConstraints = false
        self.searchButton.setTitle("검색", for: .normal)
        self.searchButton.layer.cornerRadius = 4
        self.searchButton.backgroundColor = .systemBlue
        self.searchButton.tintColor = .white
        
        self.view.addSubview(self.searchButton)
        
        NSLayoutConstraint.activate([
            self.searchButton.centerYAnchor.constraint(equalTo: self.userTextField.centerYAnchor),
            self.searchButton.widthAnchor.constraint(equalTo: self.userTextField.widthAnchor, multiplier: 0.25),
            self.searchButton.leadingAnchor.constraint(equalTo: self.userTextField.trailingAnchor, constant: 10),
            self.searchButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
        
        self.searchButton.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
    }
}
