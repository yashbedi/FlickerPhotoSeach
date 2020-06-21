//
//  DownloadImageService.swift
//  FlickerPhotoSearch
//
//  Created by Yash Bedi on 21/06/20.
//  Copyright © 2020 Yash Bedi. All rights reserved.
//

import Foundation

final class DownloadImageService {
    
    private init() { }
    
    static let shared = DownloadImageService()
    
    private var coreImageOperationQueue: OperationQueue = {
        let imageQueue = OperationQueue()
        imageQueue.name = Constants.kOperationQueueName
        imageQueue.qualityOfService = .userInteractive
        return imageQueue
    }()
    
    private let imageDataCache = NSCache<NSString, NSData>()
    func getImage(from url: URL, indexPath: IndexPath?, completion: @escaping CoreImageCompletion) {
        
        if let cachedImageData = imageDataCache.object(forKey: url.absoluteString as NSString) {
            
            // MARK: If image is available in the Cache get a copy from there.
            //            print(" GOT IMAGE FROM CACHE ")
            completion(cachedImageData as Data, indexPath, url)
            
        }else{
            
            if Reachability.currentReachabilityStatus == .notReachable {
                completion(nil,nil,url)
                return
            }
            
            // MARK: Boosting up the priority for the images which are enqueued and being downloaded already.
            
            if let coreImageOperations = coreImageOperationQueue.operations as? [CoreImageOperation],
                let firstOperation = coreImageOperations
                    .filter({ $0.url.absoluteString == url.absoluteString && $0.isFinished == false && $0.isExecuting == true }).first {
                //                print(" CHANGED PRIORITY - V.HIGH")
                firstOperation.queuePriority = .veryHigh
            }else{
                
                // MARK: The images which were never enqueued are being downloaded and processed here,
                let imageOperation = CoreImageOperation(url: url, indexPath: indexPath)
                
                if indexPath == nil {
                    //                    print(" CHANGED PRIORITY - HIGH")
                    imageOperation.queuePriority = .high
                }
                imageOperation.onCompletion = { (data, index, key) in
                    
                    if let imageData = data {
                        self.imageDataCache.setObject(imageData as NSData, forKey: key.absoluteString as NSString)
                    }
                    completion(data, index, key)
                }
                
                // MARK: Submitting the operation to the Queue
                
                coreImageOperationQueue.addOperation(imageOperation)
            }
        }
    }
    
    func prolongDownloadForImages(with url: URL) {
        
        if let coreImageOperations = coreImageOperationQueue.operations as? [CoreImageOperation],
            let firstOperation = coreImageOperations
                .filter({ $0.url.absoluteString == url.absoluteString && $0.isFinished == false && $0.isExecuting == true }).first {
            //            print(" CHANGED PRIORITY - LOW")
            firstOperation.queuePriority = .low
        }
    }
    func cancelQueuedOperations(){
        coreImageOperationQueue.cancelAllOperations()
    }
    
}
