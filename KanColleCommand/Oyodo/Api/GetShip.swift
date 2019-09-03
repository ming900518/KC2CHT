//
// Created by CC on 2019-03-24.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import HandyJSON
import RxSwift

class GetShip: JsonBean {

    var api_result: Int = 0
    var api_result_msg: String = ""
    var api_data: GetShipApiData? = GetShipApiData()

    override func process() {
        if let data = api_data {
            for (index, it) in data.api_kdock.enumerated() {
                Dock.instance.buildList[safe: index]?.onNext(Build(entity: it))
            }
            if let apiShip = data.api_ship {
                if let rawShip = Raw.instance.rawShipMap[safe: apiShip.api_ship_id] {
                    let ship = Ship(portShip: apiShip, rawShip: rawShip)
                    Fleet.instance.shipMap[apiShip.api_ship_id] = ship
                    Fleet.instance.shipWatcher.onNext(Transform.Add(Array(arrayLiteral: ship.id)))
                    User.instance.shipCount.onNext(Fleet.instance.shipMap.count)
                }
            }
            var slotIds: Array<Int> = Array()
            data.api_slotitem.forEach { item in
                let rawSlot = Raw.instance.rawSlotMap[item.api_slotitem_id]
                let slot = Slot(raw: rawSlot, port: nil)
                Fleet.instance.slotMap[item.api_id] = slot
                slotIds.append(item.api_id)
            }
            Fleet.instance.slotWatcher.onNext(Transform.Add(slotIds))
            User.instance.slotCount.onNext(Fleet.instance.slotMap.count)
        }
    }

}

class GetShipApiData: HandyJSON {

    var api_id: Int = 0
    var api_ship_id: Int = 0
    var api_kdock = Array<KDockApiData>()
    var api_ship: ApiShip? = ApiShip()
    var api_slotitem = Array<GetShipSlotItem>()

    required init() {

    }

}

class GetShipSlotItem: HandyJSON {

    var api_id: Int = 0
    var api_slotitem_id: Int = 0

    required init() {

    }

}
