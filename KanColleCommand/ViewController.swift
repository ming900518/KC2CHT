import UIKit
import SnapKit
import WebKit
import RxSwift

class ViewController: UIViewController, UIScrollViewDelegate {

    static let DEFAULT_BACKGROUND = UIColor(hexString: "#303030")
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
        //UIDevice.current.setValue(NSNumber(value: UIInterfaceOrientation.landscapeRight.rawValue), forKey: "orientation")
        self.view.backgroundColor = UIColor.black

        webView = KCWebView()
        webView.setup(parent: self.view)
        webView.load()
        self.webView.isOpaque = false;
        self.webView.backgroundColor = UIColor.black
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .always;
            webView.scalesPageToFit = true;
            //webView.scrollView.delegate = self
            //webView.scrollView.minimumZoomScale = 1.0
            //webView.scrollView.maximumZoomScale = 1.0
            //webView.scrollView.zoomScale = 1.0
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
        }

        let settingBtn = UIButton(type: .custom)
        settingBtn.setImage(UIImage(named: "setting.png"), for: .normal)
        settingBtn.imageEdgeInsets = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
        settingBtn.backgroundColor = ViewController.DEFAULT_BACKGROUND
        self.view.addSubview(settingBtn)
        settingBtn.snp.makeConstraints { maker in
            maker.width.equalTo(40)
            maker.height.equalTo(40)
            maker.right.equalTo(webView.snp.left)
            maker.top.equalTo(webView.snp.top)
        }
        settingBtn.addTarget(self, action: #selector(openSetting), for: .touchUpInside)

        let refreshBtn = UIButton(type: .custom)
        refreshBtn.setImage(UIImage(named: "reload.png"), for: .normal)
        refreshBtn.imageEdgeInsets = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
        refreshBtn.backgroundColor = ViewController.DEFAULT_BACKGROUND
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

    @objc func confirmRefresh() {
        let dialog = UIAlertController(title: nil, message: "前往登入方式切換器", preferredStyle: .alert)
        dialog.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        dialog.addAction(UIAlertAction(title: "確定", style: .default) { action in
            self.reloadGame()
        })
        present(dialog, animated: true)
    }

    @objc func openSetting() {
        let settingVC = SettingVC()
        present(settingVC, animated: true)
        //if #available(iOS 13.0, *) {
        //    settingVC.isModalInPresentation = true
        //}
    }

    @objc func reloadGame() {
        self.webView.loadBlankPage()
        self.webView.loadChanger()
    }

}
