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
}
