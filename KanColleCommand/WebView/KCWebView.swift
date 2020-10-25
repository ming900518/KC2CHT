import Foundation
import WebKit
import SnapKit
import ScreenType
import UIKit

class KCWebView: UIWebView {

    func setup(parent: UIView) {
        parent.addSubview(self)
        if (UIScreen.current == .iPhone5_5) {
            self.snp.makeConstraints { maker in
                maker.width.equalTo(parent.snp.width).inset(40)
                maker.height.equalTo(self.snp.width).inset(131.2)
                maker.top.equalTo(parent.snp.top)
                maker.centerX.equalTo(parent.snp.centerX)
            }
        } else if (UIScreen.current == .iPhone4_7) {
            self.snp.makeConstraints { maker in
                maker.width.equalTo(parent.snp.width).inset(40)
                maker.height.equalTo(self.snp.width).inset(117.5)
                maker.top.equalTo(parent.snp.top)
                maker.centerX.equalTo(parent.snp.centerX)
            }
        } else if (UIScreen.current == .iPhone4_0) {
            self.snp.makeConstraints { maker in
                maker.width.equalTo(parent.snp.width).inset(40)
                maker.height.equalTo(self.snp.width).inset(97.5)
                maker.top.equalTo(parent.snp.top)
                maker.centerX.equalTo(parent.snp.centerX)
            }
        } else {
            self.snp.makeConstraints { maker in
                maker.height.equalTo(parent.snp.height).inset(10.5)
                maker.width.equalTo(parent.snp.width).inset(40)
                maker.top.equalTo(parent)
                maker.centerX.equalTo(parent)
                maker.centerY.equalTo(parent.snp.centerY)
            }
        }

        NotificationCenter.default.addObserver(self, selector: #selector(gameStart), name: Constants.START_EVENT, object: nil)
        self.mediaPlaybackRequiresUserAction = false
        self.delegate = self
    }

    func load() {
        var connection = String()
        if Setting.getconnection() == 0 {
            connection = "about:blank"
        } else if Setting.getconnection() == 1 {
            connection = Constants.HOME_PAGE
        } else if Setting.getconnection() == 2 {
            connection = Constants.OOI
        } else if Setting.getconnection() == 3 {
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
            self.stringByEvaluatingJavaScript(from: Constants.FULL_SCREEN_SCRIPT)
//            if (UIScreen.current <= .iPhone6_5) {
            self.stringByEvaluatingJavaScript(from: Constants.darkBG)
//            }
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

public extension UIDevice {

    static let screenSize: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        func mapToDevice(identifier: String) -> String {
            #if os(iOS)
            switch identifier {
            case "iPod7,1", "iPod9,1", "iPhone6,1", "iPhone6,2","iPhone8,4":
                return "4.0"
            case "iPhone7,2", "iPhone8,1", "iPhone9,1", "iPhone9,3", "iPhone10,1", "iPhone10,4", "iPhone12,8":               return "4.7"
            case "iPhone7,1", "iPhone8,2", "iPhone9,2", "iPhone9,4", "iPhone10,2", "iPhone10,5":
                return "5.5"
            case "iPhone10,3", "iPhone10,6", "iPhone11,2", "iPhone12,3":
                return "5.8"
            case "iPhone11,8", "iPhone12,1":
                return "6.1"
            case "iPhone11,4", "iPhone11,6", "iPhone12,5":
                return "6.5"
            case "iPad4,4", "iPad4,5", "iPad4,6", "iPad4,7", "iPad4,8", "iPad4,9", "iPad5,1", "iPad5,2", "iPad11,1", "iPad11,2":
                return "7.9"
            case "iPad4,1", "iPad4,2", "iPad4,3", "iPad5,3", "iPad5,4", "iPad6,3", "iPad6,4", "iPad6,11", "iPad6,12", "iPad7,5", "iPad7,6":
                return "9.7"
            case "iPad7,11", "iPad7,12", "iPad11,6", "iPad11,7":
                return "10.2"
            case "iPad7,3", "iPad7,4", "iPad11,3", "iPad11,4", "iPad11,5":
                return "10.5"
            case "iPad13,1", "iPad13,2":
                return "10.9"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4", "iPad8,9", "iPad8,10":
                return "11.0"
            case "iPad6,7", "iPad6,8", "iPad7,1", "iPad7,2", "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8", "iPad8,11", "iPad8,12":
                return "12.9"
            case "i386", "x86_64":
                return "\(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:
                return "Unknown Device" + identifier
            }
            #endif
        }
        return mapToDevice(identifier: identifier)
    }()

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
//        if Setting.getconnection() == 4 {
//            OperationQueue.main.addOperation {
//                self.stringByEvaluatingJavaScript(from: Constants.DMM_COOKIES)
//            }
//        }
        let url1 = URL(string: "http://www.dmm.com/netgame/social/-/gadgets/=/app_id=854854/")
        let url2 = URL(string: "http://ooi.moe/poi")
        let url3 = URL(string: "http://kancolle.su/poi")
        let url4 = URL(string: "http://ooi.moe/")
        let url5 = URL(string: "http://kancolle.su/")
        if webView.request?.url == url1 {
            print("URL: " + (webView.request?.url!.absoluteString)!)
            if(UIScreen.current < .iPad9_7){
                self.scrollView.minimumZoomScale = 1.0
                self.scrollView.maximumZoomScale = 1.0
                self.scrollView.zoomScale = 1.0
            } else {
                print("Using iPad, nothing needs to be modified.")
            }
        } else if webView.request?.url == url2 || webView.request?.url == url3 {
            print("URL: " + (webView.request?.url!.absoluteString)!)
            let screenSize = UIDevice.screenSize
            print("OOI poi mode detected, resize.")
            print("Screen size should be " + screenSize + " inch.")
            if (screenSize == "4.0") {
                self.scrollView.minimumZoomScale = 0.41
                self.scrollView.maximumZoomScale = 0.41
                self.scrollView.setZoomScale(0.41, animated: false)
                self.scrollView.isScrollEnabled = false
            } else if (screenSize == "4.7") {
                self.scrollView.minimumZoomScale = 0.49
                self.scrollView.maximumZoomScale = 0.49
                self.scrollView.setZoomScale(0.49, animated: false)
                self.scrollView.isScrollEnabled = false
            } else if (screenSize == "5.5") {
                self.scrollView.minimumZoomScale = 0.546
                self.scrollView.maximumZoomScale = 0.546
                self.scrollView.setZoomScale(0.546, animated: false)
                self.scrollView.isScrollEnabled = false
            } else if (screenSize == "5.8") {
                self.scrollView.minimumZoomScale = 0.495
                self.scrollView.maximumZoomScale = 0.495
                self.scrollView.setZoomScale(0.495, animated: false)
                self.scrollView.isScrollEnabled = false
            } else if (screenSize == "6.1") {
                self.scrollView.minimumZoomScale = 0.55
                self.scrollView.maximumZoomScale = 0.55
                self.scrollView.setZoomScale(0.55, animated: false)
                self.scrollView.isScrollEnabled = false
            } else if (screenSize == "6.5") {
                self.scrollView.minimumZoomScale = 0.545
                self.scrollView.maximumZoomScale = 0.545
                self.scrollView.setZoomScale(0.545, animated: false)
                self.scrollView.isScrollEnabled = false
            } else if (screenSize == "7.9") {
                self.scrollView.minimumZoomScale = 0.79
                self.scrollView.maximumZoomScale = 0.79
                self.scrollView.setZoomScale(0.79, animated: false)
                self.scrollView.isScrollEnabled = false
            } else if (screenSize == "9.7") {
                self.scrollView.minimumZoomScale = 0.79
                self.scrollView.maximumZoomScale = 0.79
                self.scrollView.setZoomScale(0.79, animated: false)
                self.scrollView.isScrollEnabled = false
            } else if (screenSize == "10.2") {
                self.scrollView.minimumZoomScale = 0.833
                self.scrollView.maximumZoomScale = 0.833
                self.scrollView.setZoomScale(0.833, animated: false)
                self.scrollView.isScrollEnabled = false
            } else if (screenSize == "10.5") {
                self.scrollView.minimumZoomScale = 0.86
                self.scrollView.maximumZoomScale = 0.86
                self.scrollView.setZoomScale(0.86, animated: false)
                self.scrollView.isScrollEnabled = false
            } else if (screenSize == "10.9") {
                self.scrollView.minimumZoomScale = 0.918
                self.scrollView.maximumZoomScale = 0.918
                self.scrollView.setZoomScale(0.918, animated: false)
                self.scrollView.isScrollEnabled = false
            } else if (screenSize == "11.0") {
                self.scrollView.minimumZoomScale = 0.92
                self.scrollView.maximumZoomScale = 0.92
                self.scrollView.setZoomScale(0.92, animated: false)
                self.scrollView.isScrollEnabled = false
            } else if (screenSize == "12.9") {
                self.scrollView.minimumZoomScale = 1
                self.scrollView.maximumZoomScale = 1
                self.scrollView.setZoomScale(1, animated: false)
                self.scrollView.isScrollEnabled = false
            } else {
                print("Unknown Device.")
            }
        } else if webView.request?.url == url4 || webView.request?.url == url5 {
            print("URL: " + (webView.request?.url!.absoluteString)!)
            print("OOI Auto Login Started.")
            let loginAccount = Setting.getLoginAccount()
            let loginPasswd = Setting.getLoginPasswd()
            if Setting.getAttemptTime() == 0 {
                Setting.saveAttemptTime(value: 1)
                let loginJS = "javascript:document.getElementById('login_id').value = '" + loginAccount + "'; document.getElementById('password').value = '" + loginPasswd + "'; document.getElementById('mode3').checked = 'true'; document.forms[0].submit();"
                self.stringByEvaluatingJavaScript(from: loginJS)
            }
        } else {
            print("URL: " + (webView.request?.url!.absoluteString)!)
            self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
            self.scrollView.setZoomScale(1, animated: false)
            //self.scrollView.zoomScale = 1
            self.scrollView.isScrollEnabled = true
        }
        saveCookie()
    }

    public func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
    }

}
