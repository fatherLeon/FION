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
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        
        return label
    }()
    
    private let enemyNicknameLabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        
        return label
    }()
    
    private let scoreLabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .preferredFont(forTextStyle: .title1)
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var mainStackView = {
        let stackView = UIStackView(arrangedSubviews: [myNicknameLabel, scoreLabel, enemyNicknameLabel])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 6
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("잘못된 접근입니다.")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    func updateLabelText(_ data: MatchObject, target: String) {
        if data.matchInfo[0].nickname == target {
            self.myNicknameLabel.text = data.matchInfo[0].nickname
            self.enemyNicknameLabel.text = data.matchInfo[1].nickname
            self.scoreLabel.text = data.matchInfo[0].matchDetail.matchResult
        } else {
            self.myNicknameLabel.text = data.matchInfo[1].nickname
            self.enemyNicknameLabel.text = data.matchInfo[0].nickname
            self.scoreLabel.text = data.matchInfo[1].matchDetail.matchResult
        }
    }
    
    // MARK: - UI
    private func configureUI() {
        self.contentView.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            mainStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5),
            
            mainStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 30),
            mainStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -30)
        ])
    }
}
