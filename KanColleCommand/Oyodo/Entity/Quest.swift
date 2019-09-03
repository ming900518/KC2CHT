//
// Created by CC on 2019-02-13.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation

class Quest {

    var id: Int = 0
    var title: String = ""
    var state: Int = 0
    var category: Int = 0
    var current: Int = 0
    var max: Int = 0
    var description: String = ""
    var type: MissionRequireType = .NONE

    init(bean: QuestListBean?) {
        setup(bean: bean)
    }

    func setup(bean: QuestListBean?) {
        if let bean = bean {
            id = bean.api_no
            title = bean.api_title
            state = bean.api_state
            category = bean.api_category
            if let missionData = getMissionData(byId: id) {
                max = missionData.require
                description = missionData.description
                type = missionData.type
                if (bean.api_state == 3) {
                    current = max
                } else {
                    switch (bean.api_progress_flag) {
                    case 1:
                        current = Int(ceil(Float(max) / 2.0))
                        break
                    case 2:
                        current = Int(floor(Float(max) * 0.8))
                        break
                    default:
                        current = 0
                        break
                    }
                }
            }
        }
    }

}
