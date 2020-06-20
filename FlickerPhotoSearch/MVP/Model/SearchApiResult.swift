//
//  SearchApiResult.swift
//  FlickerPhotoSearch
//
//  Created by Yash Bedi on 20/06/20.
//  Copyright © 2020 Yash Bedi. All rights reserved.
//

import Foundation

struct SearchAPIResult: Decodable {
    let photos: Photos
    let stat: String
}

struct Photos: Decodable {
    let page, pages, perpage: Int
    let total: String
    let photo: [Photo]
}

struct Photo: Decodable, Equatable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
    
    func imageUrl(_ size:String = "m") -> URL? {
      if let url =  URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_\(size).jpg") {
        return url
      }
      return nil
    }
}
func == (lhs: Photo, rhs: Photo) -> Bool {
  return lhs.id == rhs.id
}
