//
//  MatchTableViewCell.swift
//  FIONApp
//
//  Created by 강민수 on 2023/04/02.
//

import UIKit

class MatchTableViewCell: UITableViewCell {
    
    static let identifier = "MatchTableViewCell"

    private let myNicknameLabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .preferredFont(forTextStyle: .title1)
        label.textAlignment = .center
        
        return label
    }()
    
    private let enemyNicknameLabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .preferredFont(forTextStyle: .title1)
        label.textAlignment = .center
        
        return label
    }()
    
    private let scoreLabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var mainStackView = {
        let stackView = UIStackView(arrangedSubviews: [myNicknameLabel, scoreLabel, enemyNicknameLabel])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 6
        
        return stackView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("잘못된 접근입니다.")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    func updateLabelText(_ data: MatchObject) {
        
    }
    
    // MARK: - UI
    private func configureUI() {
        NSLayoutConstraint.activate([
            mainStackView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 40),
            mainStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -40),
            
            mainStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
    }
}
