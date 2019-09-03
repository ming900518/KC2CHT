//
// Created by CC on 2019-03-24.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import HandyJSON
import RxSwift

class CreateShipSpeedChange: JsonBean {

    var api_result: Int = 0
    var api_result_msg: String = ""

    override func process() {
        let buildDockId = parse(value: params["api_kdock_id"])
        if let buildDock = Dock.instance.buildList[safe: buildDockId - 1] {
            do {
                let build = try buildDock.value()
                build.completeTime = 0
                build.state = 3
                buildDock.onNext(build)
            } catch {
                print("Got error in CreateShipSpeedChange process")
            }
        }
    }

}
