//
// Created by CC on 2019-03-24.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import RxSwift

class Change: JsonBean {

    var api_result: Int = 0
    var api_result_msg: String = ""

    override func process() {
        let shipId = Int(params[safe: "api_ship_id"]!) ?? 0
        let fleetIdx = (Int(params[safe: "api_id"]!) ?? -1) - 1
        let shipIdx = Int(params[safe: "api_ship_idx"]!) ?? -1
        if (fleetIdx >= 0) {
            var after = Array<Int>()
            let fleet = Fleet.instance.deckShipIds[safe: fleetIdx]
            var fleetIds = Array<Int>()
            do {
                fleetIds = try fleet?.value() ?? Array()
                switch (shipId) {
                case -2:
                    for (index, id) in fleetIds.enumerated() {
                        if (index != 0) {
                            after.append(-1)
                        } else {
                            after.append(id)
                        }
                    }
                    break
                case -1:
                    after.append(contentsOf: fleetIds)
                    after.remove(at: shipIdx)
                    after.append(-1)
                    break
                default:
                    after.append(contentsOf: fleetIds)
                    if let alreadyId = fleetIds[safe: shipIdx], alreadyId != -1 {
                        for (index, it) in Fleet.instance.deckShipIds.enumerated() {
                            var anotherFleet = try it.value()
                            if let targetIdx = anotherFleet.firstIndex(of: shipId), targetIdx != -1 {
                                if (fleetIdx == index) {
                                    after[targetIdx] = alreadyId
                                } else {
                                    anotherFleet[targetIdx] = alreadyId
                                    it.onNext(anotherFleet)
                                }
                            }
                        }
                    }
                    after[shipIdx] = shipId
                    break
                }
                fleet?.onNext(after)
            } catch {
                print("Got error in Change process")
            }
        }
    }

}
