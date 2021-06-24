//
//  HomeTopCollectionViewCell.swift
//  nytimes
//
//  Created by shunnamiki on 2021/06/14.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "HOME_COLLECTION_VIEW_CELL"
    var item: Article? {
        didSet {
            if let item = item {
                titleLabel.text = item.headline.main
            }
            
            if let url = item?.imageUrl {
                self.thumbnail.load(url: url)
            }
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 3
        return label
    }()
    
    let thumbnail: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit
//        img.backgroundColor = .red
        return img
    }()
    
    lazy var hStack: UIStackView = {
        let list = [thumbnail, titleLabel]
        let stack = UIStackView(arrangedSubviews: list)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .equalSpacing
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // for styles
        contentView.addSubview(hStack)
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: topAnchor),
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
