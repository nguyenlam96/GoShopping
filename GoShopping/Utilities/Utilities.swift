//
//  Utilities.swift
//  GoShopping
//
//  Created by Nguyen Lam on 12/15/18.
//  Copyright © 2018 Nguyen Lam. All rights reserved.
//

import Foundation
import UIKit

private let dateFormat = "yyyyMMddHHmmss"

func getCustomDateFormatter() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat
    return dateFormatter
}

func getImageFrom(stringData: String, withBlock: (_ image: UIImage?) -> Void ) {
    
    var image: UIImage?
    let decodeData = Data(base64Encoded: stringData, options: Data.Base64DecodingOptions(rawValue: 0))
    guard let theImageData = decodeData else {
        return
    }
    image = UIImage(data: theImageData)
    withBlock(image) // config the image ( get the roundImage)
}
