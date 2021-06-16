//
//  SearchTableViewCell.swift
//  nytimes
//
//  Created by shunnamiki on 2021/06/16.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

//    override func awakeFromNib() {
//        super.awakeFromNib()
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
    
    static let reuseIdentifier = "SEARCH_TABLE_VIEW_CELL_ID"
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .blue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
