//
// Created by CC on 2019-03-16.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import RxSwift
import HandyJSON

class BattleCombinedResult: IBattleResult {

    override func process() {
        if let ship = api_data?.api_get_ship {
            Battle.instance.get = ship.api_ship_name
        }
        Battle.instance.phaseShift(value: Phase.BattleCombinedResult)

        setMissionProgress(bean: self, type: MissionRequireType.BATTLE)
    }

}