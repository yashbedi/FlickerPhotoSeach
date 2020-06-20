//
//  FlickerPhotoCell.swift
//  FlickerPhotoSearch
//
//  Created by Yash Bedi on 19/06/20.
//  Copyright © 2020 Yash Bedi. All rights reserved.
//

import UIKit

final class FlickerPhotoCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        loaderStartAnim()
        imageView.image = #imageLiteral(resourceName: "placeHolder")
        //imageView.backgroundColor = .lightGray
    }
    func loaderStartAnim(){
        loader.isHidden = false
        loader.startAnimating()
    }
    func loaderStopAnim(){
        loader.stopAnimating()
        loader.isHidden = true
    }
}

