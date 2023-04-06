//
//  MatchTableViewCell.swift
//  FIONApp
//
//  Created by 강민수 on 2023/04/02.
//

import UIKit

class MatchTableViewCell: UITableViewCell {
    
    static let identifier = "MatchTableViewCell"
    
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
    
    required init?(coder: NSCoder) {
        fatalError("잘못된 접근입니다.")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    func updateLabelText(_ data: MatchObject, target: String) {
        if data.matchInfo[0].nickname == target {
            self.enemyNicknameLabel.text = data.matchInfo[1].nickname
            
            var scoreText = ""
            scoreText += "\(data.matchInfo[0].shoot["goalTotalDisplay"]!) "
            scoreText += data.matchInfo[0].matchDetail.matchResult
            scoreText += " \(data.matchInfo[1].shoot["goalTotalDisplay"]!)"
            
            self.scoreLabel.text = scoreText
        } else {
            self.enemyNicknameLabel.text = data.matchInfo[0].nickname
            
            var scoreText = ""
            scoreText += "\(data.matchInfo[1].shoot["goalTotalDisplay"]!) "
            scoreText += data.matchInfo[1].matchDetail.matchResult
            scoreText += " \(data.matchInfo[0].shoot["goalTotalDisplay"]!)"
            
            self.scoreLabel.text = scoreText
        }
    }
    
}

// MARK: - UI
extension MatchTableViewCell {
    private func configureUI() {
        let mainStackView = UIStackView(arrangedSubviews: [scoreLabel, enemyNicknameLabel])
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.spacing = 6
        mainStackView.distribution = .fillEqually
        
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
