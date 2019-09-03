//
// Created by CC on 2019-02-26.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import UIKit

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Dictionary {
    subscript(safe key: Key) -> Value? {
        return keys.contains(key) ? self[key] : nil
    }
}

extension UIColor {
    convenience init(hexString: String) {
        var cString = hexString.uppercased().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let length = (cString as NSString).length
        if (length < 6 || length > 7 || (!cString.hasPrefix("#") && length == 7)) {
            self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            return
        }

        if cString.hasPrefix("#") {
            cString = (cString as NSString).substring(from: 1)
        }

        var range = NSRange()
        range.location = 0
        range.length = 2
        let rString = (cString as NSString).substring(with: range)
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        var r: UInt32 = 0, g: UInt32 = 0, b: UInt32 = 0
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1.0)
    }
}

func parse(value: String?) -> Int {
    if let str = value, let parsedInt = Int(str) {
        return parsedInt
    } else {
        return -1
    }
}
