//
// Created by CC on 2019-02-12.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import RxSwift
import HandyJSON

class NDock: JsonBean {

    var api_result: Int = 0
    var api_result_msg: String = ""
    var api_data: Array<NDockApiData>?

    override func process() {
        var shipIds = Array<Int>()
        if let data = api_data {
            for (index, it) in data.enumerated() {
                do {
                    if let old = try Dock.instance.repairList[safe: index]?.value() {
                        if (old.valid() && old.state == 1 && it.api_state == 0) {
                            if let ship = Fleet.instance.shipMap[old.shipId] {
                                shipIds.append(ship.id)
                                ship.nowHp = ship.maxHp
                                ship.condition = max(40, ship.condition)
                            }
                        }
                        Dock.instance.repairList[index].onNext(Repair(entity: it))
                        shipIds.append(it.api_ship_id)
                    }
                } catch {
                    print("Got error in NDock process")
                }
            }
            Fleet.instance.shipWatcher.onNext(Transform.Change(shipIds))
        }
    }

}

class NDockApiData: HandyJSON {

    var api_member_id: Int = 0
    var api_id: Int = 0
    var api_state: Int = 0
    var api_ship_id: Int = 0
    var api_complete_time: Int64 = 0
    var api_complete_time_str: String = ""
    var api_item1: Int = 0
    var api_item2: Int = 0
    var api_item3: Int = 0
    var api_item4: Int = 0

    required init() {

    }

}
