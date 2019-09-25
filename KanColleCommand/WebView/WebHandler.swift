import UIKit
import CoreData
import Foundation
import Toaster

class WebHandler: URLProtocol, URLSessionDelegate, URLSessionDataDelegate, URLSessionTaskDelegate {

    private var dataTask: URLSessionDataTask?
    private var receivedData: Data?

    override open class func canInit(with request: URLRequest) -> Bool {
        if let path = request.url?.path {
            if (path.starts(with: "/kcs2/index.php")) {
                NotificationCenter.default.post(Notification.init(name: Constants.START_EVENT))
            }
        }
        let key = URLProtocol.property(forKey: Constants.TAG, in: request)
        var intercept = false
        if let url: URL = request.url {
//            let method = request.httpMethod ?? ""
            intercept = (key == nil)
//                    && ("GET".caseInsensitiveCompare(method) == .orderedSame)
                    && shouldIntercept(url: url)
        }
        return intercept
    }

    override open class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override open class func requestIsCacheEquivalent(_ aRequest: URLRequest, to bRequest: URLRequest) -> Bool {
        return super.requestIsCacheEquivalent(aRequest, to: bRequest)
    }

    override open func startLoading() {
        let url = self.request.url
        if (CacheManager.shouldCache(url: url) && CacheManager.isFileCached(url: url)) {
            loadResponseFromCache()
        } else {
            loadResponseFromWeb()
        }
    }

    override open func stopLoading() {
        self.dataTask?.cancel()
        self.dataTask = nil
        self.receivedData = nil
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse,
                    completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
        self.receivedData = Data()
        completionHandler(.allow)
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self.client?.urlProtocol(self, didLoad: data)
        self.receivedData?.append(data)
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let e = error {
            print("===============================================")
            print(e)
            print("===============================================")
            let retryCount = Setting.getRetryCount()
            let tag = (URLProtocol.property(forKey: Constants.TAG, in: request) as? Int ?? 0) + 1
            if (tag <= retryCount) {
                Toast(text: "第\(tag)次重试").show()
                loadResponseFromWeb()
            } else {
                self.client?.urlProtocol(self, didFailWithError: e)
            }
        } else {
            if (CacheManager.shouldCache(url: self.request.url) &&
                    ("GET".caseInsensitiveCompare(request.httpMethod ?? "") == ComparisonResult.orderedSame)) {
                CacheManager.saveFile(url: self.request.url, data: self.receivedData)
            }
            if (self.request.url?.path.caseInsensitiveCompare("/kcs2/js/main.js") == ComparisonResult.orderedSame) {
                do {
                    if let file = Bundle.main.path(forResource: "bridge", ofType: "js") {
                        let content = try Data(contentsOf: URL(fileURLWithPath: file))
                        self.client?.urlProtocol(self, didLoad: content)
                    }
                } catch {
                    print("Error append js file")
                }
            }
            self.client?.urlProtocolDidFinishLoading(self)
        }
    }

    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let credential = URLCredential.init(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(.useCredential, credential)
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }

    private class func shouldIntercept(url: URL) -> Bool {
        let path = url.path
        return (path.starts(with: "/kcs/")
                || path.starts(with: "/kcs2/")
                || path.starts(with: "/kcsapi/"))
    }

    private func loadResponseFromCache() {
        if var data = CacheManager.readFile(url: self.request.url) {
            if (self.request.url?.path.caseInsensitiveCompare("/kcs2/js/main.js") == ComparisonResult.orderedSame) {
                do {
                    if let file = Bundle.main.path(forResource: "bridge", ofType: "js") {
                        let content = try Data(contentsOf: URL(fileURLWithPath: file))
                        data.append(content)
                    }
                } catch {
                    print("Error append js file")
                }
            }
            let mimeType = Utils.getMimeType(url: self.request.url)
            let size = data.count
            let headers = [
                "Server": "nginx",
                "Content-Type": mimeType,
                "Content-Length": String(format: "%d", arguments: [size]),
                "Connection": "keep-alive",
                "Pragma": "public",
                "Cache-Control": "max-age=2592000, public",
                "Accept-Ranges": "bytes"
            ]
            let response = HTTPURLResponse(url: self.request.url!, statusCode: 200, httpVersion: "1.1", headerFields: headers)
            self.client!.urlProtocol(self, didReceive: response!, cacheStoragePolicy: .notAllowed)
            self.client!.urlProtocol(self, didLoad: data)
            self.client!.urlProtocolDidFinishLoading(self)
        } else {
            loadResponseFromWeb()
        }
    }

    private func loadResponseFromWeb() {
        let newRequest = (self.request as NSURLRequest).mutableCopy() as! NSMutableURLRequest
        newRequest.timeoutInterval = 30
        let tag = URLProtocol.property(forKey: Constants.TAG, in: request) as? Int ?? 0
        print("retry count \(tag) for \(String(describing: request.url))")
        URLProtocol.setProperty(tag + 1, forKey: Constants.TAG, in: newRequest)
        let defaultConfigObj = URLSessionConfiguration.default
        defaultConfigObj.urlCache = nil
        let defaultSession = Foundation.URLSession(configuration: defaultConfigObj, delegate: self, delegateQueue: nil)
        self.dataTask = defaultSession.dataTask(with: self.request)
        self.dataTask!.resume()
    }

}
