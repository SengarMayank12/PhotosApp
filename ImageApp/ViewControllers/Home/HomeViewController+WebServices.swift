//
//  HomeViewController+WebServices.swift
//  Gallery
//
//  Created by Mayank Sengar on 5/16/20.
//  Copyright © 2020 Mayank Sengar. All rights reserved.
//

import Foundation
import UIKit

// MARK:- WebServices

extension HomeViewController {
    
    func requestdataFromFlickr(_ searchText: String) {
        guard let url = requestURLForFlickr(searchText) else {
            return
        }
        NetworkManager.sharedManager.searchFlickrForText(searchText, url: url) { [weak self] (result, error) in
            self?.activityIndicator.isHidden = true
            self?.activityIndicator.stopAnimating()
            self?.isLoading = false
            if error == nil {
                if let result = result {
                    self?.photoSource.searchResults.append(contentsOf: result.searchResults)
                    self?.photoCollectionView.reloadData()
                }
            } else {
                self?.showAlertWithMessage(error: error)
            }
        }
    }
    
    
    func requestURLForFlickr(_ searchText: String) -> URL? {
        guard let escapedTerm = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else {
            return nil
        }
        
        let page = (photoSource.searchResults.count / FLICKR.perPageRecords)+1
        
        let URLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(FLICKR.apikey)&text=\(escapedTerm)&per_page=\(FLICKR.perPageRecords)&format=json&nojsoncallback=1&page=\(page)"
        
        guard let url = URL(string:URLString) else {
            return nil
        }
        return url
    }
    
    func showAlertWithMessage(error : Error?) {
        let refreshAlert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            refreshAlert.dismiss(animated: true, completion: nil)
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
}
