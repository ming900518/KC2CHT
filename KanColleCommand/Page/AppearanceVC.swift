//
//  AppearanceVC.swift
//  KanColleCommand
//
//  Created by Ming Chang on 6/7/20.
//  Copyright © 2020 CC. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Photos

class AppearanceVC: UIViewController, UIImagePickerControllerDelegate , UIPickerViewDataSource, UIPickerViewDelegate, UINavigationControllerDelegate {
    
    private let cellIdentifier = "AppearanceCell"
    private var appearanceTable: UITableView!
    
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
        titleText.text = "輔助程式設定"
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

        if #available(iOS 13.0, *) {
            appearanceTable = UITableView(frame: CGRect.zero, style: .insetGrouped)
        } else {
            appearanceTable = UITableView(frame: CGRect.zero, style: .grouped)
        }
        appearanceTable.delegate = self
        appearanceTable.dataSource = self
        if #available(iOS 13.0, *) {
            appearanceTable.backgroundColor = UIColor.systemGroupedBackground
        } else {
            appearanceTable.backgroundColor = UIColor.clear
        }
        self.view.addSubview(appearanceTable)
        appearanceTable.snp.makeConstraints { maker in
            maker.width.equalTo(self.view.snp.width)
            maker.top.equalTo(toolbar.snp.bottom)
            maker.bottom.equalTo(self.view.snp.bottom)
        }
    }
    @objc func close() {
        dismiss(animated: true)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.landscape = true
    }
}

extension AppearanceVC: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                let dialog = UIAlertController(title: "請選擇樣式", message: nil, preferredStyle: .actionSheet)
                if let popoverController = dialog.popoverPresentationController {
                    popoverController.sourceView = self.view
                    popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                    popoverController.permittedArrowDirections = []
                }
                dialog.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                dialog.addAction(UIAlertAction(title: "預設", style: .default) { action in
                    Setting.saveUseTheme(value: 0)
                    let result = UIAlertController(title: "請重啟App以套用", message: nil, preferredStyle: .alert)
                    result.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
                    self.present(result, animated: true)
                })
                dialog.addAction(UIAlertAction(title: "黑玻璃透明", style: .default) { action in
                    Setting.saveUseTheme(value: 1)
                    let result = UIAlertController(title: "請重啟App以套用", message: nil, preferredStyle: .alert)
                    result.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
                    self.present(result, animated: true)
                })
                self.present(dialog, animated: true)
            }
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                print("[INFO] Duration setting started by user.")
                let selector: UIAlertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
                let picker = UIPickerView()
                selector.view.addSubview(picker)
                picker.snp.makeConstraints { maker in
                    maker.width.equalTo(selector.view.snp.width)
                    maker.height.equalTo(200)
                }
                picker.dataSource = self
                picker.delegate = self
                picker.selectRow(Setting.getDrawerDuration(), inComponent: 0, animated: false)
                if let popoverController = selector.popoverPresentationController {
                    popoverController.sourceView = self.view
                    popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                    popoverController.permittedArrowDirections = []
                }
                selector.addAction(UIAlertAction(title: "確定", style: .default) { action in
                    let selected = picker.selectedRow(inComponent: 0)
                    print("Selected : \(selected)")
                    Setting.saveDrawerDuration(value: selected)
                    self.appearanceTable.reloadData()
                    print("[INFO] New duration setting has been set.")
                })
                selector.addAction(UIAlertAction(title: "取消", style: .cancel))
                self.present(selector, animated: true)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(50)
    }
}

extension AppearanceVC: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                let cell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
                cell.textLabel?.text = "輔助程式主題"
                if Setting.getUseTheme() == 0 {
                    cell.detailTextLabel?.text = "預設"
                } else {
                    cell.detailTextLabel?.text = "黑玻璃透明"
                }
                cell.accessoryType = .disclosureIndicator
                return cell
            }
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                let cell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
                cell.textLabel?.text = "輔助程式彈出速度"
                cell.detailTextLabel?.text = "\(Setting.getDrawerDuration())"
                cell.accessoryType = .disclosureIndicator
                return cell
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
        return UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
    }
    
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return CGFloat(40)
    }

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 6
    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
    }
}
