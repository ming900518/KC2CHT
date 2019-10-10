import Foundation
import WebKit
import SnapKit
import ScreenType

class KCWebView: UIWebView {

    func setup(parent: UIView) {
        parent.addSubview(self)
        if (UIScreen.current <= .iPhone5_5) { //iPhone with Home Botton
            self.snp.makeConstraints { maker in
                maker.width.equalTo(parent.snp.width).inset(40)
                maker.height.equalTo(self.snp.width).multipliedBy(Float(9) / Float(14.1))
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
        let url = URL(string: Constants.HOME_PAGE)
        loadRequest(URLRequest(url: url!))
    }

    func loadBlankPage() {
        let url = URL(string: "about:blank")
        loadRequest(URLRequest(url: url!))
    }

    @objc private func gameStart(n: Notification) {
        OperationQueue.main.addOperation {
            if (UIScreen.current <= .iPhone6_5) {
            self.stringByEvaluatingJavaScript(from: Constants.FULL_SCREEN_SCRIPT)
            self.stringByEvaluatingJavaScript(from: Constants.darkBG)
            }
        }
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
                    print("Error parse response")
                }
            }
            return false
        }

        return true
    }

    public func webViewDidStartLoad(_ webView: UIWebView) {

    }

    public func webViewDidFinishLoad(_ webView: UIWebView) {
        OperationQueue.main.addOperation {
            self.stringByEvaluatingJavaScript(from: Constants.DMM_COOKIES)
        }
    }

    public func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
    }

}
