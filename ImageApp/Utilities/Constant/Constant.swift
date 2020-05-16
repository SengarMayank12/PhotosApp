//
//  Constant.swift
//  Gallery
//
//  Created by Mayank Sengar on 5/16/20.
//  Copyright © 2020 Mayank Sengar. All rights reserved.
//

import Foundation
import UIKit

// MARK :- Defines

let KPhotoCollectionViewCell = "PhotoCollectionViewCell"

let KLayoutSelectionText = "Please select Layout"

let KFlickerSecretKey = "b1766633a8516831"

let KPhotoViewController = "PhotoViewController"

let KUnknownAPIResponse = "Unknown API response"

// MARK :- Struct

struct ImageCache {
    static let MB = 1024 * 1024
}

struct FLICKR {
    static let apikey = "cfa3b81db20d89524d6237f7944121d5"
    static let perPageRecords = 30
    static let bottomTriggerForLoadMore: CGFloat = 100
}

struct SCREEN {
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
    static let size = UIScreen.main.bounds.size
}


struct CustomError {
    static let title = "Error"
}

struct StoryBoard {
    static let main = "Main"
}


// MARK :- Enums

enum GridLayout : CGFloat {
    case small = 4
    case medium = 3
    case large = 2
    
    var descriptionText : String {
        switch self {
        case .small: return "Small layout"
        case .medium: return "Medium layout"
        case .large: return "Large layout"
        }
    }
}



