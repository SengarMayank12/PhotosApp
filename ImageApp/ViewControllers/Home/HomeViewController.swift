//
//  HomeViewController.swift
//  Gallery
//
//  Created by Mayank Sengar on 5/16/20.
//  Copyright © 2020 Mayank Sengar. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class HomeViewController : UIViewController {
    // MARK:- IBOutlet
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    // MARK:- Variables
    lazy var flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    var selectedLayout = GridLayout.medium
    var photoSource = FlickrSearchResults(searchTerm: "", searchResults: [], pages: 0) {
        didSet {
            if !photoSource.searchResults.isEmpty {
                noDataLabel.isHidden = true
            } else {
                noDataLabel.isHidden = false
            }
        }
    }
    var isLoading = false
    let animationController = AnimatorController()
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK:- Custom Method
    
    func initializeView() {
        flowLayout = UICollectionViewFlowLayout()
        updateCollectionViewEstimatedItemSizeForLayout(flowLayout)
        photoCollectionView.collectionViewLayout = flowLayout
        registerCollectionViewCellForReusableIdentifier()
        activityIndicator.hidesWhenStopped = false
        activityIndicator.isHidden = true
    }
    
    func registerCollectionViewCellForReusableIdentifier() {
        photoCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: KPhotoCollectionViewCell)
    }
    
    // MARK:- IBAction
    
    @IBAction func layoutBarButtonClicked(_ sender:UIBarButtonItem) {
        let alertController = UIAlertController(title: KLayoutSelectionText, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let largeAction = UIAlertAction(title: GridLayout.large.descriptionText, style: .default) { [weak self](action) in
            self?.updateLayout(.large)
        }
        
        let mediumAction = UIAlertAction(title: GridLayout.medium.descriptionText, style: .default) { [weak self] (action) in
            self?.updateLayout(.medium)
        }
        
        let smallAction = UIAlertAction(title: GridLayout.small.descriptionText, style: .default) { [weak self] (action) in
            self?.updateLayout(.small)
        }
        
        alertController.addAction(largeAction)
        alertController.addAction(mediumAction)
        alertController.addAction(smallAction)
        self.show(alertController, sender: self)
    }
    
    func updateCollectionViewEstimatedItemSizeForLayout(_ layout: UICollectionViewFlowLayout) {
        
        var noOfCellsPerRow: CGFloat = 0
        let spacing: CGFloat = 10
        noOfCellsPerRow = selectedLayout.rawValue
        
        
        let size = (SCREEN.width - ((noOfCellsPerRow)*spacing))/noOfCellsPerRow
        layout.itemSize = CGSize(width: size, height: size)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        
    }
    
    func updateLayout(_ gridLayout: GridLayout) {
        if selectedLayout != gridLayout {
            selectedLayout = gridLayout
            updateCollectionViewEstimatedItemSizeForLayout(flowLayout)
            photoCollectionView.reloadData()
        }
    }
    
    
    
}
