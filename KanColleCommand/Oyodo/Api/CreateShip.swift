//
// Created by CC on 2019-03-24.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation

class CreateShip: JsonBean {

    var api_result: Int = 0
    var api_result_msg: String = ""

    override func process() {
        setMissionProgress(bean: self, type: MissionRequireType.CREATE_SHIP)
    }

}
