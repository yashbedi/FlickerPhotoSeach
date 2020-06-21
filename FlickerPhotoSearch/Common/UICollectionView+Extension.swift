//
//  UICollectionView+Extension.swift
//  FlickerPhotoSearch
//
//  Created by Yash Bedi on 21/06/20.
//  Copyright © 2020 Yash Bedi. All rights reserved.
//

import UIKit

extension UICollectionView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0,
                                                 y: 0,
                                                 width: self.bounds.size.width,
                                                 height: self.bounds.size.height))
        
        
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: Constants.kFontTerb,
                                   size: 20)
        messageLabel.textColor = NaiveDarkAndLightMode.current().darkGrey
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
    }

    func restore() {
        self.backgroundView = nil
    }
}
