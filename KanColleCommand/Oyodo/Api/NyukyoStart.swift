//
// Created by CC on 2019-03-31.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import HandyJSON
import RxSwift

class NyukyoStart: JsonBean {

    var api_result: Int = 0
    var api_result_msg: String = ""

    override func process() {
        let useBucket = parse(value: params["api_highspeed"]) == 1
        if (useBucket) {
            let shipId = parse(value: params["api_ship_id"])
            if let ship = Fleet.instance.shipMap[shipId] {
                ship.nowHp = ship.maxHp
                ship.condition = max(40, ship.condition)
                Fleet.instance.shipWatcher.onNext(Transform.Change(Array(arrayLiteral: shipId)))
            }
            do {
                try Resource.instance.bucket.onNext(Resource.instance.bucket.value() - 1)
            } catch {
                print("Got error in NyukyoStart process")
            }
        }

        setMissionProgress(bean: self, type: MissionRequireType.REPAIR)
    }

}
