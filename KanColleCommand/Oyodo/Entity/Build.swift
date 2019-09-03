//
// Created by CC on 2019-02-12.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation

class Build {

    var id: Int = -1
    var state: Int = 1
    var shipId: Int = -1
    var completeTime: Int64 = -1

    init() {

    }

    init(entity: KDockApiData) {
        id = entity.api_id
        state = entity.api_state
        shipId = entity.api_created_ship_id
        let time = entity.api_complete_time
        if (state <= 0 || shipId <= 0) {
            completeTime = -1
        } else {
            completeTime = time
        }
    }

    func valid() -> Bool {
        return state > 0 && shipId > 0
    }

}