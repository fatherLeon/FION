//
//  PlayerImageHeaderView.swift
//  FIONApp
//
//  Created by 강민수 on 2023/04/21.
//

import UIKit

final class PlayerImageHeaderView: UICollectionReusableView {

    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unexpected Initalize Error")
    }

    func updateLabel(section: PlayerSection) {
        self.label.text = section.positionDescription
    }
}

extension PlayerImageHeaderView {
    
    private func configureUI() {
        let inset: CGFloat = 3
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .title3)
        
        self.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: inset),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -inset),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -inset)
        ])
    }
}
