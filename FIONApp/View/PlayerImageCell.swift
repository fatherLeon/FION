//
//  PlayerImageCell.swift
//  FIONApp
//
//  Created by 강민수 on 2023/04/21.
//

import UIKit

class PlayerImageCell: UICollectionViewCell {
    private var imageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unexpected Initalize Error")
    }
    
    func updateImage(_ image: UIImage?) {
        imageView?.image = image
    }
}

extension PlayerImageCell {
    private func configureUI() {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        self.contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
        
        self.imageView = imageView
    }
}
