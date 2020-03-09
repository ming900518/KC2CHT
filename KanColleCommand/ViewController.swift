import UIKit
import SnapKit
import WebKit
import RxSwift

class ViewController: UIViewController, UIScrollViewDelegate {

    static let DEFAULT_BACKGROUND = UIColor(white: 0.23, alpha: 1)
    private var webView: KCWebView!
    private var scrollView: UIScrollView!
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.landscape = true
        UIApplication.shared.isIdleTimerDisabled = true
        self.view.backgroundColor = UIColor.init(white: 0.185, alpha: 1)

        webView = KCWebView()
        webView.setup(parent: self.view)
        webView.load()
        webView.scrollView.isScrollEnabled = true;
        self.webView.isOpaque = false;
        self.webView.backgroundColor = UIColor.black
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .always;
            webView.scalesPageToFit = true;
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reloadGame), name: Constants.RELOAD_GAME, object: nil)

        let badlyDamageWarning = UIImageView(image: UIImage(named: "badly_damage_warning.png")?.resizableImage(
                withCapInsets: UIEdgeInsets.init(top: 63, left: 63, bottom: 63, right: 63), resizingMode: .stretch))
        badlyDamageWarning.isHidden = true
        self.view.addSubview(badlyDamageWarning)
        badlyDamageWarning.snp.makeConstraints { maker in
            maker.edges.equalTo(webView)
        }
        Oyodo.attention().watch(data: Fleet.instance.shipWatcher) { (event: Event<Transform>) in
            var show = false
            if (Battle.instance.friendCombined) {
                var phase = Phase.Idle
                do {
                    phase = try Battle.instance.phase.value()
                } catch {
                    print("Error when call phase.value()")
                }
                show = (Fleet.instance.isBadlyDamage(index: 0) || Fleet.instance.isBadlyDamage(index: 1))
                        && (phase != Phase.Idle)
            } else {
                let battleFleet = Battle.instance.friendIndex
                show = battleFleet >= 0 && Fleet.instance.isBadlyDamage(index: battleFleet)
            }
            badlyDamageWarning.isHidden = !show
            let warningAlert = UIAlertController(title: "⚠️大破⚠️", message: "あうぅっ！ 痛いってばぁっ！\n(つД`)", preferredStyle: .alert)
            warningAlert.addAction(UIAlertAction(title: "はい、はい、知っています", style: .destructive, handler: nil))
            if show == true {
                self.present(warningAlert, animated: true)
            }
        }

        let settingBtn = UIButton(type: .custom)
        settingBtn.setImage(UIImage(named: "setting.png"), for: .normal)
        settingBtn.imageEdgeInsets = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
        settingBtn.backgroundColor = UIColor.init(white: 0.185, alpha: 1)
        self.view.addSubview(settingBtn)
        if (UIScreen.current == .iPhone5_8) { //iPhone X XS 11Pro
            settingBtn.snp.makeConstraints { maker in
                maker.width.equalTo(40)
                maker.height.equalTo(40)
                maker.right.equalTo(webView.snp.left)
                maker.top.equalTo(webView.snp.top).inset(11)
            }
        } else if (UIScreen.current == .iPhone6_1) { //iPhone XR 11
            settingBtn.snp.makeConstraints { maker in
                maker.width.equalTo(40)
                maker.height.equalTo(40)
                maker.right.equalTo(webView.snp.left)
                maker.top.equalTo(webView.snp.top).inset(11)
            }
        } else if (UIScreen.current == .iPhone6_5) { //iPhone XS Max 11Pro Max
            settingBtn.snp.makeConstraints { maker in
                maker.width.equalTo(40)
                maker.height.equalTo(40)
                maker.right.equalTo(webView.snp.left)
                maker.top.equalTo(webView.snp.top).inset(11)
            }
        } else if (UIScreen.current > .iPad10_5) { //iPad Pro
            settingBtn.snp.makeConstraints { maker in
                maker.width.equalTo(40)
                maker.height.equalTo(40)
                maker.right.equalTo(webView.snp.left)
                maker.top.equalTo(webView.snp.top).inset(11)
            }
        } else {
            settingBtn.snp.makeConstraints { maker in
                maker.width.equalTo(40)
                maker.height.equalTo(40)
                maker.right.equalTo(webView.snp.left)
                maker.top.equalTo(webView.snp.top)
            }
        }
        settingBtn.addTarget(self, action: #selector(openSetting), for: .touchUpInside)

        let refreshBtn = UIButton(type: .custom)
        refreshBtn.setImage(UIImage(named: "reload.png"), for: .normal)
        refreshBtn.imageEdgeInsets = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
        refreshBtn.backgroundColor = UIColor.init(white: 0.185, alpha: 1)//ViewController.DEFAULT_BACKGROUND
        self.view.addSubview(refreshBtn)
        refreshBtn.snp.makeConstraints { maker in
            maker.width.equalTo(40)
            maker.height.equalTo(40)
            maker.right.equalTo(settingBtn.snp.right)
            maker.top.equalTo(settingBtn.snp.bottom)
        }
        refreshBtn.addTarget(self, action: #selector(confirmRefresh), for: .touchUpInside)

        let drawer = Drawer()
        drawer.attachTo(controller: self)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.loginChanger()
    }

    @objc func confirmRefresh() {
        //let dialog = UIAlertController(title: nil, message: "前往登入方式切換器", preferredStyle: .alert)
        //dialog.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        //dialog.addAction(UIAlertAction(title: "確定", style: .default) { action in
            //self.reloadGame()
        //})
        self.loginChanger()
    }

    @objc func openSetting() {
        let settingVC = SettingVC()
        present(settingVC, animated: true)
    }

    @objc func reloadGame() {
        self.webView.loadBlankPage()
        self.webView.load()
    }
    
    func cleaner() {
        print("[INFO] Cleaner started by user.")
        let dialog = UIAlertController(title: "使用須知", message: "1. 這功能會清空App所下載的Caches和Cookies\n2. 下次遊戲載入時就會重新下載Caches，Cookies會自動重設\n3. 清除完畢後會自動關閉本App以確保完整清除", preferredStyle: .alert)
        dialog.addAction(UIAlertAction(title: "取消", style: .cancel) { action in
            self.blankPage()
        })
        dialog.addAction(UIAlertAction(title: "我暸解了，執行清理", style: .destructive) { action in
            print("[INFO] Cleaner confirmed by user. Start cleaning.")
            if let cookies = HTTPCookieStorage.shared.cookies {
                for cookie in cookies {
                    HTTPCookieStorage.shared.deleteCookie(cookie)
                }
            }
            CacheManager.clearCache()
            print("[INFO] Everything cleaned.")
            let result = UIAlertController(title: "清理完成", message: "本App即將關閉", preferredStyle: .alert)
            result.addAction(UIAlertAction(title: "確定", style: .default) { action in
                exit(0)
            })
            self.present(result, animated: true)
        })
        self.present(dialog, animated: true)
    }
    
    @objc func loginChanger(){
        let dialog = UIAlertController(title: "iKanColleCommand", message: "請選擇登入遊戲方式", preferredStyle: .alert)
        dialog.addAction(UIAlertAction(title: "修改Cookies直連（推薦）", style: .default) { action in
            let url = URL(string: Constants.HOME_PAGE)
            self.webView.loadRequest(URLRequest(url: url!))
        })
        dialog.addAction(UIAlertAction(title: "ooi.moe（備用）", style: .default) { action in
            let url = URL(string: Constants.OOI)
            self.webView.loadRequest(URLRequest(url: url!))
        })
        dialog.addAction(UIAlertAction(title: "kancolle.su (Backup)", style: .default) { action in
            let url = URL(string: Constants.kcsu)
            self.webView.loadRequest(URLRequest(url: url!))
        })
        dialog.addAction(UIAlertAction(title: "取消", style: .destructive) { action in
            self.blankPage()
        })
        present(dialog, animated: true)
    }
    
    @objc func blankPage(){
        let blank = "about:blank"
        let currentPage = self.webView.request!.url!.absoluteString
        if currentPage == blank {
            let alert = UIAlertController(title: "遊戲尚未開啟", message: "請選擇以下其中一種操作", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "返回選擇登入方式", style: .default) { action in
                self.loginChanger()
                })
            alert.addAction(UIAlertAction(title: "清理Caches和Cookies", style: .default) { action in
                self.cleaner()
            })
            alert.addAction(UIAlertAction(title: "關閉本App", style: .destructive) { action in
                exit(0)
                })
            self.present(alert, animated: true)
        }
        else {
            return
        }
    }
}
