//
//  FlickrSearchResults.swift
//  Gallery
//
//  Created by Mayank Sengar on 5/16/20.
//  Copyright © 2020 Mayank Sengar. All rights reserved.
//

import Foundation

struct FlickrSearchResults {
    let searchTerm : String
    var searchResults : [FlickrPhoto]
    let pages: Int
}
