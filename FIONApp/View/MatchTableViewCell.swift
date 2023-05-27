//
//  MatchTableViewCell.swift
//  FIONApp
//
//  Created by 강민수 on 2023/04/02.
//

import UIKit

final class MatchTableViewCell: UITableViewCell {
    
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
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        
        return label
    }()
    
    private let dateLabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .preferredFont(forTextStyle: .title3)
        label.textAlignment = .center
        
        return label
    }()
    
    private let possessionLabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        
        return label
    }()
    
    private var mainStackView = UIStackView()
    private var matchInfoStackView = UIStackView()
    private var dateStackView = UIStackView()
    
    required init?(coder: NSCoder) {
        fatalError("잘못된 접근입니다.")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    func updateLabelText(_ data: MatchObject, target: String) {
        self.dateLabel.text = convertStringToFormattedString(data.matchDate)
        
        if data.matchInfo[0].nickname == target {
            self.enemyNicknameLabel.text = data.matchInfo[1].nickname
            
            var scoreText = ""
            scoreText += "\(data.matchInfo[0].shoot["goalTotalDisplay"]!) "
            scoreText += data.matchInfo[0].matchDetail.matchResult
            scoreText += " \(data.matchInfo[1].shoot["goalTotalDisplay"]!)"
            
            self.scoreLabel.text = scoreText
            self.possessionLabel.text = "\(data.matchInfo[0].matchDetail.possession)% vs \(data.matchInfo[1].matchDetail.possession)%"
        } else {
            self.enemyNicknameLabel.text = data.matchInfo[0].nickname
            
            var scoreText = ""
            scoreText += "\(data.matchInfo[1].shoot["goalTotalDisplay"]!) "
            scoreText += data.matchInfo[1].matchDetail.matchResult
            scoreText += " \(data.matchInfo[0].shoot["goalTotalDisplay"]!)"
            
            self.scoreLabel.text = scoreText
            self.possessionLabel.text = "\(data.matchInfo[1].matchDetail.possession)% vs \(data.matchInfo[0].matchDetail.possession)%"
        }
    }
    
    func convertStringToFormattedString(_ dateText: String) -> String {
        let basicDateFormatter = Date.ISOFormatter
        let matchListDateFormatter = Date.matchListDateFormatter
        
        guard let formattedDate = basicDateFormatter.date(from: dateText + "Z") else {
            return "날짜 정보 없음"
        }
        
        return matchListDateFormatter.string(from: formattedDate)
    }
}

// MARK: - UI
extension MatchTableViewCell {
    private func configureUI() {
        configureMainStackView()
        configureDateStackView()
        configureMatchInfoStackView()
    }
    
    private func configureMatchInfoStackView() {
        matchInfoStackView = UIStackView(arrangedSubviews: [scoreLabel, enemyNicknameLabel, possessionLabel])
        
        matchInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        matchInfoStackView.spacing = 2
        matchInfoStackView.distribution = .fillEqually
        
        self.mainStackView.addArrangedSubview(matchInfoStackView)
        
    }
    
    private func configureMainStackView() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        mainStackView.spacing = 20
        
        self.contentView.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            mainStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5),
            
            mainStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 30),
            mainStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -30)
        ])
    }
    
    private func configureDateStackView() {
        dateStackView = UIStackView(arrangedSubviews: [dateLabel])
        
        dateStackView.translatesAutoresizingMaskIntoConstraints = false
        dateStackView.spacing = 4
        dateStackView.alignment = .center
        dateStackView.axis = .horizontal
        
        self.mainStackView.addArrangedSubview(dateStackView)
    }
}
