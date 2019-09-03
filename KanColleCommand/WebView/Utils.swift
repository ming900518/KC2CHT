import Foundation
import UIKit

class Utils {

    open class func getQueryDictionary(url: URL) -> Dictionary<String, String> {
        var result: Dictionary<String, String> = Dictionary.init()
        if let queryString = url.query {
            let pairs = queryString.split(separator: "&", omittingEmptySubsequences: false)
            for pair in pairs {
                let component = pair.components(separatedBy: "=")
                if let key = component.first {
                    result[key] = component.last
                }
            }
        }
        return result
    }

    open class func getMimeType(url: URL?) -> String {
        var mimeType = "*/*"
        if let sourcePath = url?.path {
            if (sourcePath.hasSuffix("js")) {
                mimeType = "application/javascript"
            } else if (sourcePath.hasSuffix("json")) {
                mimeType = "application/json"
            } else if (sourcePath.hasSuffix("mp3")) {
                mimeType = "audio/mpeg"
            } else if (sourcePath.hasSuffix("png")) {
                mimeType = "image/png"
            }
        }
        return mimeType
    }

    open class func getSafeAreaInset(view: UIView) -> UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return view.safeAreaInsets
        }
        return UIEdgeInsets.zero
    }

}
