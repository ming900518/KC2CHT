//
// Created by CC on 2019-02-10.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation

class Expedition {

    var missionId: String = "0"
    var fleetIndex: Int = -1
    var returnTime: Int64 = -1

    init() {

    }

    init(entity: ApiDeckPort) {
        fleetIndex = entity.api_id
        missionId = entity.api_mission?[1] ?? ""
        returnTime = Int64(entity.api_mission?[2] ?? "-1") ?? -1
    }

    init(entity: DeckApiData) {
        fleetIndex = entity.api_id
        missionId = entity.api_mission?[1] ?? ""
        returnTime = Int64(entity.api_mission?[2] ?? "-1") ?? -1
    }

    func valid() -> Bool {
        return missionId != "0" && fleetIndex >= 0
    }

}
