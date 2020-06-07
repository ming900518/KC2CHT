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
        if (indexPath.section == 1) {
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
                cell.textLabel?.text = "使用圖片作為輔助程式背景"
                let switchView = UISwitch(frame: .zero)
                if Setting.getUsePic() == 0 {
                    switchView.setOn(false, animated: false)
                } else {
                    switchView.setOn(true, animated: false)
                }
                switchView.tag = indexPath.row // for detect which row switch Changed
                switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
                cell.accessoryView = switchView
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
    @objc public func switchChanged(_ sender : UISwitch!){
        print("table row switch Changed \(sender.tag)")
        print("The switch is \(sender.isOn ? "ON" : "OFF")")
        if sender.isOn == true {
            Setting.saveUsePic(value: 1)
            let alert = UIAlertController(title: "選擇圖片方式", message: nil, preferredStyle: .actionSheet)
            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            alert.addAction(UIAlertAction(title: "開啟相機", style: .default) { action in
                self.openCamera()
            })
            alert.addAction(UIAlertAction(title: "從相簿中選擇", style: .default) { action in
                self.openGallery()
            })
            alert.addAction(UIAlertAction.init(title: "取消", style: .cancel) { action in
                Setting.saveUsePic(value: 0)
                self.appearanceTable.reloadData()
                let result = UIAlertController(title: "操作已取消", message: "本App即將關閉", preferredStyle: .alert)
                result.addAction(UIAlertAction(title: "確定", style: .default) { action in
                    exit(0)
                })
                self.present(result, animated: true)
            })
            self.present(alert, animated: true, completion: nil)
        } else {
            Setting.saveUsePic(value: 0)
            let result = UIAlertController(title: "設定已還原", message: "本App即將關閉", preferredStyle: .alert)
            result.addAction(UIAlertAction(title: "確定", style: .default) { action in
                exit(0)
            })
            self.present(result, animated: true)
        }
    }
    public func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            Setting.saveUsePic(value: 0)
            self.appearanceTable.reloadData()
        }
    }
    public func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            Setting.saveUsePic(value: 0)
            self.appearanceTable.reloadData()
        }
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
