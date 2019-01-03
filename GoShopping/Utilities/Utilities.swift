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

extension Collection {
    var pairs: [SubSequence] {
        var start = startIndex
        return (0...count/3).map { _ in
            let end = index(start, offsetBy: 3, limitedBy: endIndex) ?? endIndex
            defer { start = end }
            return self[start..<end]
        }
    }
}
extension StringProtocol where Self: RangeReplaceableCollection {
    mutating func insert(separator: String, every n: Int) {
        indices.reversed().forEach {
            if $0 != startIndex { if distance(from: startIndex, to: $0) % n == 0 { insert(contentsOf: separator, at: $0) } }
        }
    }
    func inserting(separator: String, every n: Int) -> Self {
        var string = self
        string.insert(separator: separator, every: n)
        return string
    }
}
