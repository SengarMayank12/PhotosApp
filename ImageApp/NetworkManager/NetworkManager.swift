//
//  NetworkManager.swift
//  Gallery
//
//  Created by Mayank Sengar on 5/16/20.
//  Copyright © 2020 Mayank Sengar. All rights reserved.
//

import Foundation
import UIKit

class NetworkManager {
    
    static let sharedManager = NetworkManager()
    
    
    func searchFlickrForText(_ searchText:String, url: URL, completion: @escaping (_ result: FlickrSearchResults?,_ error: Error?) -> Void) -> Void? {
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if let _ = error {
                let APIError = NSError(domain: CustomError.title, code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:KUnknownAPIResponse])
                DispatchQueue.main.async {
                    completion(nil, APIError)
                }
                return
            }
            
            guard let _ = response as? HTTPURLResponse,
                let data = data else {
                    let APIError = NSError(domain: CustomError.title, code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:KUnknownAPIResponse])
                    DispatchQueue.main.async {
                        completion(nil, APIError)
                    }
                    return
            }
            
            do {
                
                guard let resultsDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String: AnyObject],
                    let stat = resultsDictionary["stat"] as? String else {
                        
                        let APIError = NSError(domain: CustomError.title, code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:KUnknownAPIResponse])
                        DispatchQueue.main.async {
                            completion(nil, APIError)
                        }
                        return
                }
                
                switch (stat) {
                case "ok":
                    debugPrint("Results processed OK")
                    
                case "fail":
                    if let message = resultsDictionary["message"] {
                        
                        let APIError = NSError(domain: CustomError.title, code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:message])
                        
                        DispatchQueue.main.async {
                            completion(nil, APIError)
                        }
                    } else {
                        
                        let APIError = NSError(domain: CustomError.title, code: 0, userInfo: nil)
                        
                        DispatchQueue.main.async {
                            completion(nil, APIError)
                        }
                    }
                    
                    return
                default:
                    let APIError = NSError(domain: CustomError.title, code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:KUnknownAPIResponse])
                    DispatchQueue.main.async {
                        completion(nil, APIError)
                    }
                    return
                }
                
                guard let photosContainer = resultsDictionary["photos"] as? [String: AnyObject], let photosReceived = photosContainer["photo"] as? [[String: AnyObject]] else {
                    
                    let APIError = NSError(domain: CustomError.title, code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:KUnknownAPIResponse])
                    DispatchQueue.main.async {
                        completion(nil, APIError)
                    }
                    return
                }
                
                var flickrPhotos = [FlickrPhoto]()
                
                var pages = 0
                if let totalPages = photosContainer["pages"] as? Int  {
                    pages = totalPages
                }
                
                
                for photoObject in photosReceived {
                    guard let photoID = photoObject["id"] as? String,
                        let farm = photoObject["farm"] as? Int ,
                        let server = photoObject["server"] as? String ,
                        let secret = photoObject["secret"] as? String else {
                            break
                    }
                    let flickrPhoto = FlickrPhoto(photoID: photoID, farm: farm, server: server, secret: secret)
                    
                    flickrPhotos.append(flickrPhoto)
                }
                
                DispatchQueue.main.async {
                    completion(FlickrSearchResults(searchTerm: searchText, searchResults: flickrPhotos, pages: pages), nil)
                }
                
            } catch _ {
                completion(nil, nil)
                return
            }
            
            
        }).resume()
        return nil
    }
    
}
