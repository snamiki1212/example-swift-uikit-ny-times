//
//  CharImage.swift
//  nytimes
//
//  Created by shunnamiki on 2021/06/15.
//

import Foundation
import UIKit

class TextImage {
    static func imageWith(name: String?) -> UIImage? {
        let size = CGFloat(25)
        let frame = CGRect(x: 0, y: 0, width: size, height: size)
        let nameLabel = UILabel(frame: frame)
        nameLabel.textAlignment = .center
        nameLabel.textColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: size)
        nameLabel.text = name
        UIGraphicsBeginImageContext(frame.size)
         if let currentContext = UIGraphicsGetCurrentContext() {
            nameLabel.layer.render(in: currentContext)
            let nameImage = UIGraphicsGetImageFromCurrentImageContext()
            return nameImage
         }
         return nil
   }
}
