//
//  ImageDetailViewController.swift
//  FlickerPhotoSearch
//
//  Created by Yash Bedi on 20/06/20.
//  Copyright © 2020 Yash Bedi. All rights reserved.
//

import UIKit

final class ImageDetailViewController: UIViewController {
    
    @IBOutlet fileprivate weak var imageView: UIImageView!
    
    var thumbImage: UIImage?
    var imageTitle: String = ""
    var url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = imageTitle
        imageView.image = thumbImage
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let uRL = url else { return }
        NetworkManager.shared.getImage(from: uRL) { (imageData) in
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: imageData)
            }
        }
    }
}
