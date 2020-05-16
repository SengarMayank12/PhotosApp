//
//  HomeViewController+CollectionView.swift
//  Gallery
//
//  Created by Mayank Sengar on 5/16/20.
//  Copyright © 2020 Mayank Sengar. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

// MARK:- CollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoSource.searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KPhotoCollectionViewCell, for: indexPath) as? PhotoCollectionViewCell else {return UICollectionViewCell()}
        cell.displayPhoto(photoSource.searchResults[indexPath.row])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row < photoSource.searchResults.count {
            if let thumbUrl = photoSource.searchResults[indexPath.row].thumbnail {
                ImageDownloader.sharedManager.updateOperationPriority(.normal, url: thumbUrl)
            }
        }
    }
}

// MARK:- CollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + photoCollectionView.frame.size.height >= photoCollectionView.contentSize.height - FLICKR.bottomTriggerForLoadMore && isLoading == false {
            if photoSource.pages < photoSource.searchResults.count/20 {
                if let text = searchBar.text {
                    isLoading = true
                    requestdataFromFlickr(text)
                }
            } else {
                isLoading = false
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        self.selectedIndexPath = indexPath
        if let selectedIndexPath = selectedIndexPath {
            if selectedIndexPath.row <= photoSource.searchResults.count {
                let photo = photoSource.searchResults[selectedIndexPath.row]
                if let thumbURL = photo.thumbnail {
                    if let _ = ImageDownloader.sharedManager.imageForKey(thumbURL.absoluteString) {
                        
                        if let vc = UIStoryboard(name: StoryBoard.main, bundle: nil).instantiateViewController(withIdentifier: KPhotoViewController) as? PhotoViewController {
                            vc.photo = photo
                            vc.transitioningDelegate = self
                            self.present(vc, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
}

// MARK:- UISearchBar Delegate

extension HomeViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        photoSource = FlickrSearchResults(searchTerm: "", searchResults: [], pages: 0)
        photoCollectionView.reloadData()
        
        if let text = searchBar.text {
            if !text.isEmpty {
                requestdataFromFlickr(text)
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
            }
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

