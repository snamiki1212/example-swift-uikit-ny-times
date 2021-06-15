//
//  HomeTopCollectionViewCell.swift
//  nytimes
//
//  Created by shunnamiki on 2021/06/14.
//

import UIKit

class HomeTopCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "HOME_TOP_COLLECTION_VIEW_CELL"
    var item: ArticleResponse? {
        didSet {
            titleLabel.text = item?.headline.main
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // for styles
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
