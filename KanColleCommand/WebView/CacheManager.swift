import Foundation

class CacheManager {

    class func shouldCache(url: URL?) -> Bool {
        if let path = url?.path {
            if (path.starts(with: "/kcs/") || path.starts(with: "/kcs2/") || path.starts(with: "/page/")) {
                return path.hasSuffix("js") ||
                        path.hasSuffix("json") ||
                        path.hasSuffix("mp3") ||
                        path.hasSuffix("woff2") ||
                        path.hasSuffix("jpeg") ||
                        path.hasSuffix("png")
            }
        }
        return false
    }

    class func saveFile(url: URL?, data: Data?) {
        do {
            if let path = url?.path {
                let params = Utils.getQueryDictionary(url: url!)
                let version = params["version"]
                UserDefaults.standard.set(version, forKey: path)
                let fileManager = FileManager.default
                let filePath = baseDir() + path
                if (fileManager.fileExists(atPath: filePath)) {
                    try fileManager.removeItem(atPath: filePath)
                }
                let separator = filePath.lastIndex(of: "/")
                //let dirName = filePath.substring(to: separator!)
                let dirName = String(filePath[..<separator!])
                try fileManager.createDirectory(atPath: dirName, withIntermediateDirectories: true)
                fileManager.createFile(atPath: filePath, contents: nil)
                try data?.write(to: URL(fileURLWithPath: filePath))
            }
        } catch let exception as NSError {
            NSLog("saveFile error : " + exception.localizedDescription)
        }
    }

    class func readFile(url: URL?) -> Data? {
        if let path = url?.path {
            let filePath = baseDir() + path
            let fileManager = FileManager.default
            return fileManager.contents(atPath: filePath)
        }
        return nil
    }

    class func isFileCached(url: URL?) -> Bool {
        if let url = url {
            let path = url.path
            let params = Utils.getQueryDictionary(url: url)
            let remoteVersion = params["version"] ?? ""
            let localVersion = UserDefaults.standard.object(forKey: path) as? String ?? ""
            let fileManager = FileManager.default
            let filePath = baseDir() + path
            return (remoteVersion == localVersion) && (fileManager.fileExists(atPath: filePath))
        }
        return false
    }

    private class func baseDir() -> String {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last! + "/cache"
    }

}
