//
//  NetworkManager.swift
//  FlickerPhotoSearch
//
//  Created by Yash Bedi on 20/06/20.
//  Copyright © 2020 Yash Bedi. All rights reserved.
//

import Foundation
import UIKit

final class NetworkManager {
    
    private init() { }
    
    static let shared = NetworkManager()
    
    private var task : URLSessionDataTask?
    
    func getPhotosData(for searchStr: String,with pageNum: Int, completion: @escaping ([Photo]?,String?)->Void){
        
        if Reachability.currentReachabilityStatus == .notReachable {
            completion(nil,Constants.kNoInternet)
            return
        }
        
        guard let finalSearchStr = searchStr.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else { return }

        guard let uRL = URL(string: generateURL(from: finalSearchStr, with: pageNum)) else { return }
        
        let request = URLRequest(url: uRL)
        
        task = URLSession.shared.dataTask(with: request){ (data, response, error) in
            
            if error == nil && data != nil{
                do {
                    let decoder = JSONDecoder()
                    let searchResults = try decoder.decode(SearchAPIResult.self, from: data!)
                    completion(searchResults.photos.photo,nil)
                }catch let e {
                    completion(nil,e.localizedDescription)
                }
            }else{
                completion(nil,error?.localizedDescription)
            }
        }
        task?.resume()
    }
    
    func cancelRequests(){
        task?.cancel()
    }
}

private extension NetworkManager {
    
    func generateURL(from text: String, with pageNum: Int) -> String {
        return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(Constants.kFlickrKey)&text=\(text)&per_page=50&format=json&nojsoncallback=1&page=\(pageNum)"
    }
}
