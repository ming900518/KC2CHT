//
// Created by CC on 2019-06-24.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Photos

class SettingVC: UIViewController {
    
    private let cellIdentifier = "SettingCell"
    private var settingTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let toolbar = UIView()
        if #available(iOS 13.0, *) {
            self.view.backgroundColor = UIColor.systemBackground
            //toolbar.backgroundColor = UIColor.systemFill
        } else {
            self.view.backgroundColor = UIColor(hexString: "#FBFBFB")
            //toolbar.backgroundColor = UIColor(hexString: "#FBFBFB")
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.landscape = true
        self.view.addSubview(toolbar)

        let titleBar = UIView()
        toolbar.addSubview(titleBar)
        titleBar.snp.makeConstraints { maker in
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            maker.width.equalTo(self.view.snp.width)
            maker.height.equalTo(44)
        }

        let titleText = UILabel()
        titleText.text = "設定"
        if #available(iOS 13.0, *) {
            titleText.textColor = UIColor.label
        } else {
            titleText.textColor = UIColor.black
        }
        titleBar.addSubview(titleText)
        titleText.snp.makeConstraints { maker in
            maker.center.equalTo(titleBar.snp.center)
        }

        toolbar.snp.makeConstraints { maker in
            maker.top.equalTo(self.view.snp.top)
            maker.width.equalTo(self.view.snp.width)
            maker.bottom.equalTo(titleBar.snp.bottom)
        }

        let toolbarDivider = UIView()
        if #available(iOS 13.0, *) {
            toolbarDivider.backgroundColor = UIColor.separator
        } else {
            toolbarDivider.backgroundColor = UIColor(hexString: "#DDDDDD")
        }
        toolbar.addSubview(toolbarDivider)
        toolbarDivider.snp.makeConstraints { maker in
            maker.width.equalTo(toolbar.snp.width)
            maker.height.equalTo(1)
            maker.bottom.equalTo(toolbar.snp.bottom)
        }

        let closeBtn = UIButton(type: .system)
        closeBtn.setTitle("關閉", for: .normal)
        closeBtn.addTarget(self, action: #selector(close), for: .touchUpInside)
        titleBar.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { maker in
            maker.centerY.equalTo(titleBar.snp.centerY)
            maker.right.equalTo(titleBar.snp.right).offset(-16)
        }
        CacheManager.checkCachedfiles()
        
        let fullScreenSize = UIScreen.current.rawValue
        
        if #available(iOS 13.0, *) {
            let settingTable = UITableView(frame: CGRect(x: 0, y: 20, width: fullScreenSize, height: fullScreenSize), style: .insetGrouped)
            settingTable.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
            settingTable.delegate = self
            settingTable.dataSource = self
            settingTable.separatorStyle = .singleLine
            settingTable.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            settingTable.allowsSelection = true
            settingTable.allowsMultipleSelection = false
            self.view.addSubview(settingTable)
            settingTable.snp.makeConstraints { maker in
                maker.width.equalTo(self.view.snp.width)
                maker.top.equalTo(toolbar.snp.bottom)
                maker.bottom.equalTo(self.view.snp.bottom)
            }
        } else {
            let settingTable = UITableView(frame: CGRect(x: 0, y: 20, width: fullScreenSize, height: fullScreenSize), style: .grouped)
            settingTable.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
            settingTable.delegate = self
            settingTable.dataSource = self
            settingTable.separatorStyle = .singleLine
            settingTable.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            settingTable.allowsSelection = true
            settingTable.allowsMultipleSelection = false
            self.view.addSubview(settingTable)
            settingTable.snp.makeConstraints { maker in
                maker.width.equalTo(self.view.snp.width)
                maker.top.equalTo(toolbar.snp.bottom)
                maker.bottom.equalTo(self.view.snp.bottom)
            }
        }
    }
    
    let info = [
        ["App版本"],
        ["大破警告設定", "App外觀設定"],
        ["連線重試次數（0為不重試）", "清理緩存", "啟用App File Sharing"],
        ["關於本App", "捐贈原作者"]
    ]

    @objc func close() {
        dismiss(animated: true)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.landscape = true
         }
    }

extension SettingVC: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return info[section].count
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return info.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        let cell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.accessoryType = .none
                cell.isUserInteractionEnabled = false
                return cell
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                cell.accessoryType = .disclosureIndicator
                return cell
            } else if indexPath.row == 1 {
                cell.accessoryType = .disclosureIndicator
                cell.isUserInteractionEnabled = false
                cell.textLabel?.isEnabled = false
                return cell
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                cell.accessoryType = .disclosureIndicator
                return cell
            } else if indexPath.row == 1 {
                cell.accessoryType = .disclosureIndicator
                return cell
            } else if indexPath.row == 2 {
                cell.accessoryType = .disclosureIndicator
                if Setting.getchangeCacheDir() == 1 {
                    cell.textLabel?.isEnabled = false
                }
                return cell
            }
        } else if indexPath.section == 3 {
            if indexPath.row == 0 {
                cell.accessoryType = .disclosureIndicator
                return cell
            } else if indexPath.row == 1 {
                cell.accessoryType = .disclosureIndicator
                return cell
            }
        }
        //if let tableLabel = cell.textLabel {
            //tableLabel.text = "\(info[indexPath.section][indexPath.row])"
        //}
        return UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
    }
}

extension SettingVC: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            let title = ""
            return title
        } else if section == 1 {
            let title = "App設定"
            return title
        } else if section == 1 {
            let title = "連線"
            return title
        } else {
            let title = "關於"
            return title
        }
    }
    
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
