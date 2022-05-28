import Foundation
import WebKit
import SnapKit
import ScreenType
import UIKit

class KCWebView: UIWebView {
    
    var inset = 0.0
    let screenSize = UIDevice.screenSize
    
    func setup(parent: UIView) {
        let screenSize = UIDevice.screenSize
        parent.addSubview(self)
        self.snp.makeConstraints { maker in
            if (screenSize == 5.5) {
                inset = 131.2
                maker.height.equalTo(self.snp.width).inset(inset)
            } else if (screenSize == 4.7) {
                inset = 117.5
                maker.height.equalTo(self.snp.width).inset(inset)
//            } else if (screenSize == 4.0) {
//                inset = 97.5
//                maker.height.equalTo(self.snp.width).inset(inset)
            } else {
                inset = 10.5
                maker.height.equalTo(parent.snp.height).inset(inset)
            }
            maker.width.equalTo(parent.snp.width).inset(40)
            maker.top.equalTo(parent)
            maker.centerX.equalTo(parent)
            maker.centerY.equalTo(parent.snp.centerY)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(gameStart), name: Constants.START_EVENT, object: nil)
        self.mediaPlaybackRequiresUserAction = false
        self.delegate = self
        self.autoresizesSubviews = true
    }
    
    func load() {
        var connection = String()
        if Setting.getconnection() == 0 {
            connection = "about:blank"
        } else if Setting.getconnection() == 1 || Setting.getconnection() == 2 || Setting.getconnection() == 3 || Setting.getconnection() == 6 || Setting.getconnection() == 7 || Setting.getconnection() == 8 {
            connection = Constants.HOME_PAGE
        } else if Setting.getconnection() == 4 || Setting.getconnection() == 5 {
            connection = Constants.OOI
        }
        let url = URL(string: connection)
        loadRequest(URLRequest(url: url!))
        loadCookie()
    }
    
    
    func loadBlankPage() {
        let url = URL(string: "about:blank")
        loadRequest(URLRequest(url: url!))
    }
    
    func saveCookie() {
        let cookieJar: HTTPCookieStorage = HTTPCookieStorage.shared
        if let cookies = cookieJar.cookies {
            let data: Data = NSKeyedArchiver.archivedData(withRootObject: cookies)
            let ud: UserDefaults = UserDefaults.standard
            ud.set(data, forKey: "cookie")
        }
    }
    
    func loadCookie() {
        let ud: UserDefaults = UserDefaults.standard
        let data: Data? = ud.object(forKey: "cookie") as? Data
        if let cookie = data {
            let datas: NSArray? = NSKeyedUnarchiver.unarchiveObject(with: cookie) as? NSArray
            if let cookies = datas {
                for c in cookies {
                    if let cookieObject = c as? HTTPCookie {
                        HTTPCookieStorage.shared.setCookie(cookieObject)
                    }
                }
            }
        }
    }
    
    @objc private func gameStart(n: Notification) {
        OperationQueue.main.addOperation {
//            self.stringByEvaluatingJavaScript(from: Constants.FULL_SCREEN_SCRIPT)
            if (UIDevice.current.userInterfaceIdiom != .pad) {
                self.stringByEvaluatingJavaScript(from: Constants.darkBG)
            }
        }
    }
    
    private var isConnectedToVpn: Bool {
        if let settings = CFNetworkCopySystemProxySettings()?.takeRetainedValue() as? Dictionary<String, Any>,
           let scopes = settings["__SCOPED__"] as? [String:Any] {
            for (key, _) in scopes {
                if key.contains("tap") || key.contains("tun") || key.contains("ppp") || key.contains("ipsec") {
                    return true
                }
            }
        }
        return false
    }
}

extension KCWebView: UIWebViewDelegate {
    
    public func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: NavigationType) -> Bool {
        if (request.url?.scheme == "kcwebview") {
            if let params = request.url?.query {
                do {
                    let decoded = params.removingPercentEncoding!
                        .replacingOccurrences(of: "\\n", with: "")
                        .replacingOccurrences(of: " ", with: "")
                    let jsonData = decoded.data(using: .utf8)!
                    let dic = try JSONSerialization.jsonObject(with: jsonData) as? [String: String]
                    let url: String = dic?["url"] ?? ""
                    let header: String = dic?["request"] ?? ""
                    let body: String = dic?["response"] ?? ""
                    if (url.contains("kcsapi")) {
                        print(url)
                        print(header)
                        print(body)
                        Oyodo.attention().api(url: url, request: header, response: body.replacingOccurrences(of: "svdata=", with: ""))
                    }
                } catch {
                    print("[Error] Error parse response")
                }
            }
            return false
        }
        
        return true
    }
    
    public func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    public func webViewDidFinishLoad(_ webView: UIWebView) {
        
        if #available(iOS 15, *) {
            print("iOS 15 detected, fix game.")
            self.stringByEvaluatingJavaScript(from: Constants.ios15Fix)
            print("URL: " + (webView.request?.url!.absoluteString)!)
        }
        
        if Setting.getconnection() == 6 || Setting.getconnection() == 8 {
            OperationQueue.main.addOperation {
                self.stringByEvaluatingJavaScript(from: Constants.DMM_COOKIES)
            }
        }
        
        let url1 = URL(string: "http://www.dmm.com/netgame/social/-/gadgets/=/app_id=854854/")
        let url2 = URL(string: "http://ooi.moe/poi")
        let url3 = URL(string: "http://kancolle.su/poi")
        let url4 = URL(string: "http://ooi.moe/")
        let url5 = URL(string: "http://kancolle.su/")
        if webView.request?.url == url1 {
            if Setting.getconnection() == 2 || Setting.getconnection() == 3 || Setting.getconnection() == 6 || Setting.getconnection() == 7 || Setting.getconnection() == 8 {
                            self.stringByEvaluatingJavaScript(from: Constants.FULL_SCREEN_SCRIPT)
                        }
                        if (UIScreen.current < .iPad9_7) {
                            self.scrollView.minimumZoomScale = 1.0
                            self.scrollView.maximumZoomScale = 1.0
                            self.scrollView.zoomScale = 1.0
                        } else {
                            print("Using iPad, nothing needs to be modified.")
                        }
        } else if webView.request?.url == url2 || webView.request?.url == url3 {
            print("URL: " + (webView.request?.url!.absoluteString)!)
            print("OOI poi mode detected, resize.")
            print("Screen size should be " + String(screenSize) + " inch.")
            if (screenSize == 4.0) {
                self.scrollView.minimumZoomScale = 0.41
                self.scrollView.maximumZoomScale = 0.41
                self.scrollView.setZoomScale(0.41, animated: false)
                self.scrollView.isScrollEnabled = false
            } else if (screenSize == 4.7) {
                self.scrollView.minimumZoomScale = 0.49
                self.scrollView.maximumZoomScale = 0.49
                self.scrollView.setZoomScale(0.49, animated: false)
                self.scrollView.isScrollEnabled = false
            } else if (screenSize == 5.4) {
                self.scrollView.minimumZoomScale = 0.546
                self.scrollView.maximumZoomScale = 0.546
                self.scrollView.setZoomScale(0.546, animated: false)
                self.scrollView.isScrollEnabled = false
            } else if (screenSize == 5.5) {
                self.scrollView.minimumZoomScale = 0.546
                self.scrollView.maximumZoomScale = 0.546
                self.scrollView.setZoomScale(0.546, animated: false)
                self.scrollView.isScrollEnabled = false
            } else if (screenSize == 5.8) {
                self.scrollView.minimumZoomScale = 0.495
                self.scrollView.maximumZoomScale = 0.495
                self.scrollView.setZoomScale(0.495, animated: false)
                self.scrollView.isScrollEnabled = false
            } else if (screenSize == 6.1) {
                self.scrollView.minimumZoomScale = 0.55
                self.scrollView.maximumZoomScale = 0.55
                self.scrollView.setZoomScale(0.55, animated: false)
                self.scrollView.isScrollEnabled = false
            } else if (screenSize == 6.5) {
                self.scrollView.minimumZoomScale = 0.545
                self.scrollView.maximumZoomScale = 0.545
                self.scrollView.setZoomScale(0.545, animated: false)
                self.scrollView.isScrollEnabled = false
            } else if (screenSize == 6.7) {
                self.scrollView.minimumZoomScale = 0.545
                self.scrollView.maximumZoomScale = 0.545
                self.scrollView.setZoomScale(0.545, animated: false)
                self.scrollView.isScrollEnabled = false
            } else if (screenSize == 7.9) {
                self.scrollView.minimumZoomScale = 0.79
                self.scrollView.maximumZoomScale = 0.79
                self.scrollView.setZoomScale(0.79, animated: false)
                self.scrollView.isScrollEnabled = false
            } else if (screenSize == 9.7) {
                self.scrollView.minimumZoomScale = 0.79
                self.scrollView.maximumZoomScale = 0.79
                self.scrollView.setZoomScale(0.79, animated: false)
                self.scrollView.isScrollEnabled = false
            } else if (screenSize == 10.2) {
                self.scrollView.minimumZoomScale = 0.833
                self.scrollView.maximumZoomScale = 0.833
                self.scrollView.setZoomScale(0.833, animated: false)
                self.scrollView.isScrollEnabled = false
            } else if (screenSize == 10.5) {
                self.scrollView.minimumZoomScale = 0.86
                self.scrollView.maximumZoomScale = 0.86
                self.scrollView.setZoomScale(0.86, animated: false)
                self.scrollView.isScrollEnabled = false
            } else if (screenSize == 10.9) {
                self.scrollView.minimumZoomScale = 0.918
                self.scrollView.maximumZoomScale = 0.918
                self.scrollView.setZoomScale(0.918, animated: false)
                self.scrollView.isScrollEnabled = false
            } else if (screenSize == 11.0) {
                self.scrollView.minimumZoomScale = 0.92
                self.scrollView.maximumZoomScale = 0.92
                self.scrollView.setZoomScale(0.92, animated: false)
                self.scrollView.isScrollEnabled = false
            } else if (screenSize == 12.9 || screenSize == 12.91) {
                self.scrollView.minimumZoomScale = 1
                self.scrollView.maximumZoomScale = 1
                self.scrollView.setZoomScale(1, animated: false)
                self.scrollView.isScrollEnabled = false
            } else {
                print("Unknown Device.")
            }
        } else if webView.request?.url == url4 || webView.request?.url == url5 {
            if Setting.getconnection() == 5 {
                print("[INFO] URL: " + (webView.request?.url!.absoluteString)!)
                print("[INFO] OOI Auto Login Started.")
                let loginAccount = Setting.getLoginAccount()
                let loginPasswd = Setting.getLoginPasswd()
                if Setting.getAttemptTime() == 0 {
                    Setting.saveAttemptTime(value: 1)
                    let loginJS = "javascript:document.getElementById('login_id').value = '" + loginAccount + "'; document.getElementById('password').value = '" + loginPasswd + "'; document.getElementById('mode3').checked = 'true'; document.forms[0].submit();"
                    self.stringByEvaluatingJavaScript(from: loginJS)
                }
            }
        } else {
            print(screenSize)
            if screenSize < 7 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                    print("Device is not iPad, fix iframe.")
                    self.stringByEvaluatingJavaScript(from: Constants.iframeFix)
                    var contentHeightCGFloat: CGFloat?
                    if let contentHeightDoubleValue = Double(self.stringByEvaluatingJavaScript(from: "document.body.offsetHeight;") ?? "") {
                        contentHeightCGFloat = (CGFloat(contentHeightDoubleValue))
                    }
                    let resizeValue = contentHeightCGFloat! / (UIScreen.main.bounds.height * 2) - 0.14
                    self.scrollView.minimumZoomScale = resizeValue
                    self.scrollView.maximumZoomScale = resizeValue
                    self.scrollView.setZoomScale(resizeValue, animated: false)
                    self.scrollView.isScrollEnabled = false
                }
            }
        }
        saveCookie()
    }
    
    public func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
    }
    
}
