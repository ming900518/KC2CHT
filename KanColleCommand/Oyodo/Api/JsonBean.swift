//
// Created by CC on 2019-02-09.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import HandyJSON

class JsonBean: HandyJSON {

    var params = Dictionary<String, String>()

    required init() {

    }

    func process() {

    }

    func setParams(form: String) {
        form.split(separator: "&")
                .map { substring -> Array<Substring> in
                    return substring.replacingOccurrences(of: "%5F", with: "_")
                            .replacingOccurrences(of: "%2D", with: "-")
                            .split(separator: "=")
                }.forEach { s in
                    params[String(s[0])] = String(s[1])
                }
    }

}