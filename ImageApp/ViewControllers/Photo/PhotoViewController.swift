//
//  PhotoViewController.swift
//  Gallery
//
//  Created by Mayank Sengar on 22/05/19.
//  Copyright © 2020 Mayank Sengar. All rights reserved.
//

import AVFoundation
import UIKit

class PhotoViewController: UIViewController {
    
    // MARK:- IBOutlet
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK:- Variables
    var photo: FlickrPhoto!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
    
    
    func prepareView() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        if let largeImageURL = photo.largeImageURL {
            if let image =  ImageDownloader.sharedManager.imageForKey(largeImageURL.absoluteString) {
                imageView.image = image
                activityIndicator.alpha = 0.0
            } else {
                activityIndicator.style = .whiteLarge
                activityIndicator.color = UIColor.orange
                activityIndicator.startAnimating()
                activityIndicator.isHidden = false
                ImageDownloader.sharedManager.downloadImage(largeImageURL, .large, photoID: photo.photoID, priority: .high) { [weak self] (photo, error) in
                    if let photo = photo {
                        self?.imageView.image = photo.image
                    }
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.removeFromSuperview()
                }
                
                if let thumbURL = photo.thumbnail {
                    if let image = ImageDownloader.sharedManager.imageForKey(thumbURL.absoluteString){
                        imageView.image = image
                    }
                }
            }
        }
    }
    
    func frameForPhotoInSize(_ size: CGSize) ->  CGRect{
        if let thumbURL = photo.thumbnail {
            if let image = ImageDownloader.sharedManager.imageForKey(thumbURL.absoluteString){
                let size = image.size
                let frame = AVMakeRect(aspectRatio: size, insideRect: imageView.frame)
                return frame
            }
        }
        return CGRect.zero
    }
    
    @IBAction func crossbuttonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK :- ViewController Transition protocol

extension PhotoViewController: PhotoTransitionProtocol {
    
    func imageWindowFrame() -> CGRect {
        if let thumbURL = photo.thumbnail {
            if let image = ImageDownloader.sharedManager.imageForKey(thumbURL.absoluteString){
                let size = image.size
                let frame = frameForPhotoInSize(size)
                return frame
            }
        }
        return CGRect.zero
    }
    
    func transitionWillStart() {
        imageView.alpha = 0.0
    }
    
    func transitionDidEnd() {
        imageView.alpha = 1.0
    }
    
}

