//
// Created by CC on 2019-03-31.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import HandyJSON
import RxSwift

class RemodelSlot: JsonBean {

    var api_result: Int = 0
    var api_result_msg: String = ""

    override func process() {
        setMissionProgress(bean: self, type: MissionRequireType.REMODEL_SLOT)
    }

}
