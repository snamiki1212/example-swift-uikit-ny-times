//
//  SearchTableViewCell.swift
//  nytimes
//
//  Created by shunnamiki on 2021/06/16.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    var item: Article? {
        didSet {
            title.text = item?.headline.main
        }
    }
    
    let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 3
        return label
    }()
    
    lazy var vStack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [self.title])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        
        // layout
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        stack.isLayoutMarginsRelativeArrangement = true
        
        return stack
    }()
    
    static let reuseIdentifier = "SEARCH_TABLE_VIEW_CELL_ID"
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // styles
        contentView.backgroundColor = .white
        
        // for stack
        contentView.addSubview(vStack)
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: topAnchor),
            vStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            vStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
