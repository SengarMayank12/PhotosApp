//
//  HomeViewController+Transition.swift
//  Gallery
//
//  Created by Mayank Sengar on 5/16/20.
//  Copyright © 2020 Mayank Sengar. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

// MARK :- ViewControllerTransitionprotocol

extension HomeViewController: PhotoTransitionProtocol {
    
    func imageWindowFrame() -> CGRect {
        
        if let indexPath = selectedIndexPath {
            let attributes = photoCollectionView.layoutAttributesForItem(at: indexPath)
            let cellRect = attributes!.frame
            let frame = photoCollectionView.convert(cellRect, to: self.view)
            
            let photo =  self.photoSource.searchResults[indexPath.row]
            if let thumbURL = photo.thumbnail {
                if let image = ImageDownloader.sharedManager.imageForKey(thumbURL.absoluteString){
                    let size = image.size
                    let newFrame = AVMakeRect(aspectRatio: size, insideRect: frame)
                    return newFrame
                }
            }
        }
        return CGRect.zero
    }
    
    func transitionWillStart() {
        if let selectedIndexPath = selectedIndexPath {
            if selectedIndexPath.row <= photoSource.searchResults.count {
                if let cell = photoCollectionView.cellForItem(at: selectedIndexPath) as? PhotoCollectionViewCell {
                    cell.imageView.alpha = 0.0
                }
            }
        }
        
    }
    
    func transitionDidEnd() {
        if let selectedIndexPath = selectedIndexPath {
            if selectedIndexPath.row <= photoSource.searchResults.count {
                if let cell = photoCollectionView.cellForItem(at: selectedIndexPath) as? PhotoCollectionViewCell {
                    cell.imageView.alpha = 1.0
                }
            }
        }
    }
    
}

extension HomeViewController: UIViewControllerTransitioningDelegate {
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if let selectedIndexPath = selectedIndexPath {
            if selectedIndexPath.row <= photoSource.searchResults.count {
                let photo = photoSource.searchResults[selectedIndexPath.row]
                
                if let thumbURL = photo.thumbnail {
                    if let image = ImageDownloader.sharedManager.imageForKey(thumbURL.absoluteString){
                        animationController.setupPhotoTransition(image: image, fromDelegate: self, toDelegate: presented as! PhotoTransitionProtocol)
                        animationController.reverse = false
                        return animationController
                    }
                }
            }
        }
        
        return nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if let selectedIndexPath = selectedIndexPath {
            if selectedIndexPath.row <= photoSource.searchResults.count {
                let photo = photoSource.searchResults[selectedIndexPath.row]
                if let thumbURL = photo.thumbnail {
                    if let _ = ImageDownloader.sharedManager.imageForKey(thumbURL.absoluteString){                    animationController.reverse = true
                        return animationController
                    }
                }
            }
        }
        return nil
    }
}

