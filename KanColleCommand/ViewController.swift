import UIKit
import SnapKit
import WebKit
import RxSwift
import UserNotifications

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
        if Setting.getUseTheme() == 1 {
            self.view.backgroundColor = UIColor.init(white: 0, alpha: 1)
        } else {
            self.view.backgroundColor = UIColor.init(white: 0.185, alpha: 1)
        }
        
        if Setting.getfirstStartup() != 0 {
            if Setting.getconnection() != 1 && Setting.getconnection() != 2 && Setting.getconnection() != 3 && Setting.getconnection() != 4 && Setting.getconnection() != 5 && Setting.getconnection() != 6 && Setting.getconnection() != 7 && Setting.getconnection() != 8 {
                openSetting()
            }
        }
        webView = KCWebView()
        webView.setup(parent: self.view)
        webView.load()
        Setting.saveAttemptTime(value: 0)
        if Setting.getconnection() == 1 {
            if self.isConnectedToVpn == true {
                if Setting.getfirstStartup() != 0 {
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                    UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                    let notificationCenter = UNUserNotificationCenter.current()
                    let content = UNMutableNotificationContent()
                    content.title = "偵測到使用VPN"
                    content.body = "ACGP用戶請至設定中將大小調整為1，以免出現白邊"
                    let identifier = "VPN Notification"
                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: nil)
                    notificationCenter.add(request) { (error) in
                        if let error = error {
                            print("Error \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
        webView.scrollView.isScrollEnabled = true;
        self.webView.isOpaque = false;
        self.webView.backgroundColor = UIColor.black;
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
        if Setting.getOyodo() != 1 {
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
                if Setting.getwarningAlert() == 1 {
                    let warningAlert = UIAlertController(title: "⚠️ 大破 ⚠️", message: "あうぅっ！ 痛いってばぁっ！\n(つД`)", preferredStyle: .alert)
                    warningAlert.addAction(UIAlertAction(title: "はい、はい、知っています", style: .destructive, handler: nil))
                    if show == true {
                        self.present(warningAlert, animated: true)
                    }
                } else if Setting.getwarningAlert() == 2 {
                    let notificationCenter = UNUserNotificationCenter.current()
                    let warningAlert = UNMutableNotificationContent()
                    warningAlert.title = "⚠️ 大破 ⚠️"
                    warningAlert.body = "あうぅっ！ 痛いってばぁっ！(つД`)"
                    warningAlert.sound = UNNotificationSound.default
                    let identifier = "EHDA Notification"
                    let request = UNNotificationRequest(identifier: identifier, content: warningAlert, trigger: nil)
                    if show == true {
                        notificationCenter.add(request) { (error) in
                            if let error = error {
                                print("Error \(error.localizedDescription)")
                            }
                        }
                    }
                }
            }
        }
        let screenSize = UIDevice.screenSize
        let settingBtn = UIButton(type: .custom)
        settingBtn.setImage(UIImage(named: "setting.png"), for: .normal)
        settingBtn.imageEdgeInsets = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
        if Setting.getUseTheme() == 1 {
            settingBtn.backgroundColor = UIColor.init(white: 0, alpha: 1)
        } else {
            settingBtn.backgroundColor = UIColor.init(white: 0.185, alpha: 1)
        }
        self.view.addSubview(settingBtn)
        if (screenSize == "5.4"){ //iPhone mini
            settingBtn.snp.makeConstraints { maker in
                maker.width.equalTo(35)
                maker.height.equalTo(35)
                maker.right.equalTo(webView.snp.left)
                maker.top.equalTo(webView.snp.top).inset(20)
            }
        } else {
            settingBtn.snp.makeConstraints { maker in
                maker.width.equalTo(40)
                maker.height.equalTo(40)
                maker.right.equalTo(webView.snp.left)
                if (screenSize == "5.8" || screenSize == "6.1" || screenSize == "6.5" || screenSize == "6.7" || screenSize == "10.9" || screenSize == "11.0" || screenSize == "12.9Round") { //iDevices with round bezel
                    maker.top.equalTo(webView.snp.top).inset(30)
                } else {
                    maker.top.equalTo(webView.snp.top)
                }
            }
        }
        if #available(iOS 14.0, *) {
            let settingAction = UIAction(
                title: "開啓App設定"
            ) { (_) in
                self.openSetting()
            }
            let appearanceAction = UIAction(
                title: "開啓外觀設定"
            ) { (_) in
                self.openAppearance()
            }
            let menuActions = [settingAction, appearanceAction]
            settingBtn.showsMenuAsPrimaryAction = true
            settingBtn.menu = UIMenu(title: "", children: menuActions)
        } else {
            settingBtn.addTarget(self, action: #selector(openSetting), for: .touchUpInside)
        }
        
        let refreshBtn = UIButton(type: .custom)
        refreshBtn.setImage(UIImage(named: "reload.png"), for: .normal)
        refreshBtn.imageEdgeInsets = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
        if Setting.getUseTheme() == 1 {
            refreshBtn.backgroundColor = UIColor.init(white: 0, alpha: 1)
        } else {
            refreshBtn.backgroundColor = UIColor.init(white: 0.185, alpha: 1)
        }
        self.view.addSubview(refreshBtn)
        refreshBtn.snp.makeConstraints { maker in
            if (screenSize == "5.4"){ //iPhone mini
                maker.width.equalTo(35)
                maker.height.equalTo(35)
                maker.right.equalTo(webView.snp.left)
                maker.bottom.equalTo(webView.snp.bottom).inset(5)
            } else if (screenSize == "5.8" || screenSize == "6.1" || screenSize == "6.5" || screenSize == "6.7") { //iPhones with round bezel
                maker.width.equalTo(40)
                maker.height.equalTo(40)
                maker.bottom.equalTo(webView.snp.bottom).inset(10)
            } else {
                maker.width.equalTo(40)
                maker.height.equalTo(40)
                maker.right.equalTo(settingBtn.snp.right)
                maker.top.equalTo(settingBtn.snp.bottom)
            }
        }
        if #available(iOS 14.0, *) {
            let confirmAction = UIAction(
                title: "確定"
            ) { (_) in
                Setting.saveAttemptTime(value: 0)
                self.reloadGame()
            }
            let menuActions = [confirmAction]
            refreshBtn.showsMenuAsPrimaryAction = true
            refreshBtn.menu = UIMenu(title: "確定重新整理？", children: menuActions)
        } else {
            refreshBtn.addTarget(self, action: #selector(confirmRefresh), for: .touchUpInside)
        }
        
        if ProcessInfo().operatingSystemVersion.majorVersion < 14 {
            let appearanceBtn = UIButton(type: .custom)
            if #available(iOS 13.0, *) {
                let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
                appearanceBtn.setImage(UIImage(systemName: "pencil", withConfiguration: boldConfig), for: .normal)
                appearanceBtn.tintColor = UIColor.white
            } else {
                appearanceBtn.setImage(UIImage(named: "refresh.png"), for: .normal)
            }
            appearanceBtn.imageEdgeInsets = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
            if Setting.getUseTheme() == 1 {
                appearanceBtn.backgroundColor = UIColor.init(white: 0, alpha: 1)
            } else {
                appearanceBtn.backgroundColor = UIColor.init(white: 0.185, alpha: 1)
            }
            self.view.addSubview(appearanceBtn)
            appearanceBtn.snp.makeConstraints { maker in
                if (screenSize == "5.4"){ //iPhone mini
                    maker.width.equalTo(35)
                    maker.height.equalTo(35)
                } else {
                    maker.width.equalTo(40)
                    maker.height.equalTo(40)
                }
                maker.centerX.equalTo(refreshBtn.snp.centerX)
                maker.bottom.equalTo(view.snp.bottom).inset(20)
            }
            appearanceBtn.addTarget(self, action: #selector(openAppearance), for: .touchUpInside)
        }
        Drawer().attachTo(controller: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Setting.getfirstStartup() == 0 {
            let firstStartup = UIAlertController(title: "歡迎使用iKanColleCommand！", message: "偵測到初次使用，將開啟設定畫面\n請設定連線方式", preferredStyle: .alert)
            firstStartup.addAction(UIAlertAction(title: "了解", style: .default) { action in
                self.openSetting()
            })
            self.present(firstStartup, animated: true)
        }
    }
    
    @objc func confirmRefresh() {
        let dialog = UIAlertController(title: nil, message: "重新整理頁面", preferredStyle: .alert)
        dialog.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        dialog.addAction(UIAlertAction(title: "確定", style: .default) { action in
            Setting.saveAttemptTime(value: 0)
            self.reloadGame()
        })
        present(dialog, animated: true)
    }
    
    @objc func openSetting() {
        let settingVC = SettingVC()
        present(settingVC, animated: true)
    }
    
    @objc func openAppearance() {
        let appearanceVC = AppearanceVC()
        present(appearanceVC, animated: true)
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
            let result = UIAlertController(title: "清理完成", message: nil, preferredStyle: .alert)
            result.addAction(UIAlertAction(title: "確定", style: .default) { action in
                self.blankPage()
            })
            self.present(result, animated: true)
        })
        self.present(dialog, animated: true)
    }
    
    @objc func blankPage(){
        let blank = "about:blank"
        let currentPage = self.webView.request!.url!.absoluteString
        if currentPage == blank {
            var titleText: String?
            titleText = "遊戲尚未開啟"
            let alert = UIAlertController(title: titleText, message: "請選擇以下其中一種操作", preferredStyle: .alert)
            if Setting.getconnection() == 0 {
                alert.addAction(UIAlertAction(title: "開啟設定", style: .default) { action in
                    self.openSetting()
                })
            } else {
                
            }
            alert.addAction(UIAlertAction(title: "清理Caches和Cookies", style: .default) { action in
                self.cleaner()
            })
            alert.addAction(UIAlertAction(title: "關閉本App", style: .destructive) { action in
                exit(0)
            })
            self.present(alert, animated: true)
        } else {
            return
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

extension UIDevice {
    
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
            case "iPhone7,2", "iPhone8,1", "iPhone9,1", "iPhone9,3", "iPhone10,1", "iPhone10,4", "iPhone12,8":
                return "4.7"
            case "iPhone13,1":
                return "5.4"
            case "iPhone7,1", "iPhone8,2", "iPhone9,2", "iPhone9,4", "iPhone10,2", "iPhone10,5":
                return "5.5"
            case "iPhone10,3", "iPhone10,6", "iPhone11,2", "iPhone12,3":
                return "5.8"
            case "iPhone11,8", "iPhone12,1":
                return "6.1"
            case "iPhone11,4", "iPhone11,6", "iPhone12,5", "iPhone13,2", "iPhone13,3":
                return "6.5"
            case "iPhone13,4":
                return "6.7"
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
            case "iPad6,7", "iPad6,8", "iPad7,1", "iPad7,2":
                return "12.9"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8", "iPad8,11", "iPad8,12":
                return "12.9Round"
            case "i386", "x86_64", "arm64":
                return "\(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:
                return "Unknown Device" + identifier
            }
            #endif
        }
        return mapToDevice(identifier: identifier)
    }()
    
}
