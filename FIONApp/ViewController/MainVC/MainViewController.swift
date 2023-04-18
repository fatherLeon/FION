//
//  ViewController.swift
//  FIONApp
//
//  Created by 강민수 on 2023/03/05.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Properties
    private let modelManager = MainUIModel()
    
    // MARK: - UI Properties
    private var logoImageView = UIImageView()
    private var userTextField = UITextField()
    private var searchButton = UIButton(type: .roundedRect)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    @objc func didTapSearchButton() {
        guard let nickname = self.userTextField.text else { return }
        
        userNetworkManager = NetworkManager(type: ContentType.userInfo(nickname: nickname))
        
        userNetworkManager?.fetchDataByJson(to: UserInfoObject.self) { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let matchesVC = MatchesViewController(style: .insetGrouped)
                    
                    matchesVC.userName = data.name
                    matchesVC.userID = data.userId
                    
                    self?.navigationController?.pushViewController(matchesVC, animated: true)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.presentErrorAlert(message: error.localizedDescription)
                }
            }
        }
    } 
}

extension MainViewController: UITextFieldDelegate {
}

// MARK: - UI
extension MainViewController {
    
    private func presentErrorAlert(message: String) {
        let alertController = UIAlertController(title: message,
                                                message: nil,
                                                preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .cancel)
        
        alertController.addAction(action)
        
        present(alertController, animated: true)
    }
    
    private func configureUI() {
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .systemBackground
        
        configureLogoImageView()
        configureUserTextField()
        configureSearchButton()
    }
    
    private func configureLogoImageView() {
        self.logoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.logoImageView.contentMode = .scaleAspectFill
        self.logoImageView.image = Bundle.main.logo
        self.logoImageView.clipsToBounds = true
        
        self.view.addSubview(self.logoImageView)
        
        NSLayoutConstraint.activate([
            self.logoImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.logoImageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.logoImageView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.logoImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.1)
        ])
    }
    
    private func configureUserTextField() {
        self.userTextField.delegate = self
        
        self.userTextField.translatesAutoresizingMaskIntoConstraints = false
        self.userTextField.borderStyle = .roundedRect
        self.userTextField.backgroundColor = .systemGray
        self.userTextField.textColor = .systemGreen
        
        let attributedOption: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
        let placeholderText = NSAttributedString(string: "유저 닉네임을 입력해주세요", attributes: attributedOption)
        
        self.userTextField.attributedPlaceholder = placeholderText
        
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
