//
//  PlayerImageCell.swift
//  FIONApp
//
//  Created by 강민수 on 2023/04/21.
//

import UIKit

class PlayerImageCell: UICollectionViewCell {
    
    private let infoStackView = UIStackView()
    
    private var imageView: UIImageView?
    private var seasonImageView: UIImageView?
    private var playerNameLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unexpected Initalize Error")
    }
    
    func updateUI(_ model: PlayerModel) {
        imageView?.image = model.image
        seasonImageView?.image = model.seasonImage
        playerNameLabel?.text = model.name
    }
}

extension PlayerImageCell {
    private func configureUI() {
        configurePlayerImageView()
        cofigurePlayerInfoStackView()
        configureMainStackView()
    }
    
    private func configurePlayerImageView() {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        self.contentView.addSubview(imageView)
        
        self.imageView = imageView
    }
    
    private func cofigurePlayerInfoStackView() {
        let playerNameLabel = UILabel()
        
        playerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        playerNameLabel.adjustsFontSizeToFitWidth = true
        playerNameLabel.font = .preferredFont(forTextStyle: .body)
        playerNameLabel.textAlignment = .center
        playerNameLabel.numberOfLines = 1
        
        let seasonImageView = UIImageView()
        
        seasonImageView.translatesAutoresizingMaskIntoConstraints = false
        seasonImageView.contentMode = .scaleAspectFit
        
        seasonImageView.setContentHuggingPriority(.required, for: .horizontal)
        seasonImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        infoStackView.addArrangedSubview(seasonImageView)
        infoStackView.addArrangedSubview(playerNameLabel)
        
        self.seasonImageView = seasonImageView
        self.playerNameLabel = playerNameLabel
    }
    
    private func configureMainStackView() {
        guard let imageView = self.imageView else { return }
        
        let stackView = UIStackView(arrangedSubviews: [imageView, infoStackView])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 6
        
        self.contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5),
            stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5)
        ])
    }
}
