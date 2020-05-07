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
                print("[INFO] File Cached.")
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
    class func clearCache() {
        let filePath = baseDir()
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: filePath)
            print("[INFO] Cache cleaned.")
        }
        catch{
            print("[INFO] Error to clean cache, does cache ever exist?")
        }
        //try? FileManager.default.removeItem(at: filePathString)
        return //nil
    }
    class func checkCachedfiles() {
        let filePath = baseDir()
        let fileManager = FileManager.default
        let number = try? fileManager.contentsOfDirectory(atPath: filePath)
        guard let count = number?.count else {
            return print("[INFO] Seems nothing had been cached.")

        }
        if count > 0 {
            return print("[INFO] Something had been cached in dir.")
        } else{
            return print("[INFO] Seems nothing had been cached.")
        }
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
        if Setting.getchangeCacheDir() == 1 {
            print("[WARN] BETA FEATURE 1 HAS BEEN ACTIVATED, NOT GOING TO SAVE ANY CACHES IN THE OLD DIR.")
            print("[INFO] Using Documents as cache dir.")
            return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        } else {
            print("[INFO] Using Library/Caches/cache as cache dir.")
            return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last! + "/cache"
        }
        }
    }
