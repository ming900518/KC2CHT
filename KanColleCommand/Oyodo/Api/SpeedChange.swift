//
// Created by CC on 2019-03-24.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import HandyJSON
import RxSwift

class SpeedChange: JsonBean {

    var api_result: Int = 0
    var api_result_msg: String = ""

    override func process() {
        let repairDockId = parse(value: params["api_ndock_id"])
        if (repairDockId > 0) {
            do {
                let repairDock = Dock.instance.repairList[repairDockId - 1]
                let dockEntity = try repairDock.value()
                // ship recovery
                if let ship = Fleet.instance.shipMap[dockEntity.shipId] {
                    ship.nowHp = ship.maxHp
                    ship.condition = max(40, ship.condition)
                    Fleet.instance.shipWatcher.onNext(Transform.Change(Array(arrayLiteral: ship.id)))
                }
                // clear ndock
                dockEntity.state = 1
                dockEntity.shipId = -1
                dockEntity.completeTime = -1
                repairDock.onNext(dockEntity)
            } catch {
                print("Got error in SpeedChange process")
            }
            do {
                // use bucket
                let bucketCount = try Resource.instance.bucket.value()
                Resource.instance.bucket.onNext(bucketCount - 1)
            } catch {
                print("Got error in SpeedChange process")
            }
        }
    }

}
