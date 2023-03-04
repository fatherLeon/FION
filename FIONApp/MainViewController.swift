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

