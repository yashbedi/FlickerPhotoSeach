//
//  NetworkManager.swift
//  FlickerPhotoSearch
//
//  Created by Yash Bedi on 20/06/20.
//  Copyright © 2020 Yash Bedi. All rights reserved.
//

import Foundation
import UIKit

let Key = "6ff7d82a370f1a9ac37c207975dcb341"
let Secret = "8c90a5047f44389a"

final class NetworkManager {
    
    private init() { }
    
    static let shared = NetworkManager()
    
    private var task : URLSessionDataTask?
        
    private let imageDataCache = NSCache<NSString, NSData>()
    
    func getPhotos(for searchStr: String,with pageNum: Int, completion: @escaping ([Photo]?,String?)->Void){
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
    
    func getImage(from url: URL, completion: @escaping (Data)->Void) {
        if let cachedImageData = imageDataCache.object(forKey: url.absoluteString as NSString) {
            print("--GOT IT FROM CACHE..")
            completion(cachedImageData as Data)
        }else{
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let imageData = data {
                    self.imageDataCache.setObject(imageData as NSData, forKey: url.absoluteString as NSString)
                    completion(imageData)
                }
            }.resume()
        }
    }
    
    func cancelRequests(){
        task?.cancel()
    }
    private func generateURL(from text: String, with pageNum: Int) -> String {
        return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(Key)&text=\(text)&per_page=20&format=json&nojsoncallback=1&page=\(pageNum)"
    }
}
