//
//  ViewController.swift
//  FIONApp
//
//  Created by 강민수 on 2023/03/05.
//

import UIKit

class MainViewController: UIViewController {
    
    var logoImageView = UIImageView()
    var userTextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        configureUserTextField()
    }
}

extension MainViewController {
    func configureUserTextField() {
        self.userTextField.translatesAutoresizingMaskIntoConstraints = false
        self.userTextField.borderStyle = .roundedRect
        self.userTextField.placeholder = "유저 닉네임을 입력해주세요"
        self.userTextField.textColor = .systemGreen
        
        self.view.addSubview(self.userTextField)
        
        NSLayoutConstraint.activate([
            self.userTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            self.userTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            self.userTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
    }
}
