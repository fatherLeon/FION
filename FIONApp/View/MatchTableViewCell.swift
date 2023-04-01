//
//  MatchTableViewCell.swift
//  FIONApp
//
//  Created by 강민수 on 2023/04/02.
//

import UIKit

class MatchTableViewCell: UITableViewCell {
    
    static let identifier = "MatchTableViewCell"

    let myNicknameLabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .preferredFont(forTextStyle: .title1)
        
        return label
    }()
    
    let enemyNicknameLabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .preferredFont(forTextStyle: .title1)
        
        return label
    }()
    
    let scoreLabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .preferredFont(forTextStyle: .largeTitle)
        
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("잘못된 접근입니다.")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
}
