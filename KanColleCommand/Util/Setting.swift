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

}