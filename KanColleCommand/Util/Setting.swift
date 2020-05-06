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
}
