//
//  Photo.swift
//  Gallery
//
//  Created by Mayank Sengar on 5/16/20.
//  Copyright © 2020 Mayank Sengar. All rights reserved.
//

import Foundation
import UIKit

struct Photo {
    let image: UIImage?
    let type: ImageType
    let photoID: String
}

enum ImageType {
    case thumb  
    case large
}
