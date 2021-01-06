//
// Created by CC on 2019-06-27.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation

class Setting {

    private static let kRetryCount = "RetryCountKey" //重试次数

    static func getRetryCount() -> Int {
        return UserDefaults.standard.integer(forKey: kRetryCount)
    }

    static func saveRetryCount(value: Int) {
        UserDefaults.standard.set(value, forKey: kRetryCount)
    }
    
    private static let kwarningAlert = "warningAlert" //大破警告種類

    static func getwarningAlert() -> Int {
        return UserDefaults.standard.integer(forKey: kwarningAlert)
    }

    static func savewarningAlert(value: Int) {
        UserDefaults.standard.set(value, forKey: kwarningAlert)
    }
    
    private static let kchangeCacheDir = "changeCacheDir" //變更緩存目錄
    
    static func getchangeCacheDir() -> Int {
        return UserDefaults.standard.integer(forKey: kchangeCacheDir)
    }

    static func savechangeCacheDir(value: Int) {
        UserDefaults.standard.set(value, forKey: kchangeCacheDir)
    }
    
    private static let kfirstStartup = "firstStartup" //首次啟動
    
    static func getfirstStartup() -> Int {
        return UserDefaults.standard.integer(forKey: kfirstStartup)
    }

    static func savefirstStartup(value: Int) {
        UserDefaults.standard.set(value, forKey: kfirstStartup)
    }
    
    private static let kconnection = "connection" //連線方式
    
    static func getconnection() -> Int {
        return UserDefaults.standard.integer(forKey: kconnection)
    }

    static func saveconnection(value: Int) {
        UserDefaults.standard.set(value, forKey: kconnection)
    }
    
    private static let kAppIcon = "AppIconChange"
    
    static func getAppIconChange() -> Int {
        return UserDefaults.standard.integer(forKey: kAppIcon)
    }

    static func saveAppIconChange(value: Int) {
        UserDefaults.standard.set(value, forKey: kAppIcon)
    }
    
    private static let kUseTheme = "UseTheme"
    
    static func getUseTheme() -> Int {
        return UserDefaults.standard.integer(forKey: kUseTheme)
    }

    static func saveUseTheme(value: Int) {
        UserDefaults.standard.set(value, forKey: kUseTheme)
    }
    
    private static let kDrawerDuration = "SetDrawerAnimationDuration"
    
    static func getDrawerDuration() -> Int {
        return UserDefaults.standard.integer(forKey: kDrawerDuration)
    }

    static func saveDrawerDuration(value: Int) {
        UserDefaults.standard.set(value, forKey: kDrawerDuration)
    }
    
    private static let kOyodo = "UseOyodo"
    
    static func getOyodo() -> Int {
        return UserDefaults.standard.integer(forKey: kOyodo)
    }

    static func saveOyodo(value: Int) {
        UserDefaults.standard.set(value, forKey: kOyodo)
    }
    
    private static let kLoginAccount = "LoginAccount"
    
    static func getLoginAccount() -> String {
        return UserDefaults.standard.string(forKey: kLoginAccount) ?? ""
    }

    static func saveLoginAccount(value: String) {
        UserDefaults.standard.set(value, forKey: kLoginAccount)
    }
    
    private static let kLoginPasswd = "LoginPassword"
    
    static func getLoginPasswd() -> String {
        return UserDefaults.standard.string(forKey: kLoginPasswd) ?? ""
    }

    static func saveLoginPasswd(value: String) {
        UserDefaults.standard.set(value, forKey: kLoginPasswd)
    }
    
    private static let kAttemptTime = "AutoLoginAttemptTime"
    
    static func getAttemptTime() -> Int {
        return UserDefaults.standard.integer(forKey: kAttemptTime)
    }

    static func saveAttemptTime(value: Int) {
        UserDefaults.standard.set(value, forKey: kAttemptTime)
    }
    
    private static let kCustomProxyIP = "CustomProxyIP"
    
    static func getCustomProxyIP() -> String {
        return UserDefaults.standard.string(forKey: kCustomProxyIP) ?? ""
    }

    static func saveCustomProxyIP(value: String) {
        UserDefaults.standard.set(value, forKey: kCustomProxyIP)
    }
    
    private static let kCustomProxyPort = "CustomProxyPort"
    
    static func getCustomProxyPort() -> String {
        return UserDefaults.standard.string(forKey: kCustomProxyPort) ?? ""
    }

    static func saveCustomProxyPort(value: String) {
        UserDefaults.standard.set(value, forKey: kCustomProxyPort)
    }
    
    private static let kCustomProxyUser = "CustomProxyUser"
    
    static func getCustomProxyUser() -> String {
        return UserDefaults.standard.string(forKey: kCustomProxyUser) ?? ""
    }

    static func saveCustomProxyUser(value: String) {
        UserDefaults.standard.set(value, forKey: kCustomProxyUser)
    }
    
    private static let kCustomProxyPass = "CustomProxyPass"
    
    static func getCustomProxyPass() -> String {
        return UserDefaults.standard.string(forKey: kCustomProxyPass) ?? ""
    }

    static func saveCustomProxyPass(value: String) {
        UserDefaults.standard.set(value, forKey: kCustomProxyPass)
    }
    
    private static let kBDPstatus = "BDPstatus"
    
    static func getBDPstatus() -> Bool {
        return UserDefaults.standard.bool(forKey: kBDPstatus)
    }

    static func saveBDPstatus(value: Bool) {
        UserDefaults.standard.set(value, forKey: kBDPstatus)
    }
}
