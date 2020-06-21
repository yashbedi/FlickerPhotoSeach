//
//  ImageDetailViewController.swift
//  FlickerPhotoSearch
//
//  Created by Yash Bedi on 20/06/20.
//  Copyright © 2020 Yash Bedi. All rights reserved.
//

import UIKit

final class ImageDetailViewController: BaseViewController {
    
    @IBOutlet fileprivate weak var imageView: UIImageView!
    
    var thumbImage: UIImage?
    var imageTitle: String = ""
    var url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = imageTitle
        imageView.image = thumbImage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let uRL = url else { return }
        DownloadImageService.shared.getImage(from: uRL, indexPath: nil) { (data, index, url) in
            if data != nil {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data!)
                }
            }
        }
    }
}
