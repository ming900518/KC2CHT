//
// Created by CC on 2019-03-24.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import HandyJSON
import RxSwift

class SlotDeprive: JsonBean {

    var api_result: Int = 0
    var api_result_msg: String = ""
    var api_data: SlotDepriveApiData? = SlotDepriveApiData()

    override func process() {
        var ids = Array<Int>()
        if let setShip = api_data?.api_ship_data?.api_set_ship, let rawShip = Raw.instance.rawShipMap[setShip.api_ship_id] {
            let ship = Ship(portShip: setShip, rawShip: rawShip)
            Fleet.instance.shipMap[setShip.api_id] = ship
            ids.append(setShip.api_id)
        }
        if let unsetShip = api_data?.api_ship_data?.api_set_ship, let rawShip = Raw.instance.rawShipMap[unsetShip.api_ship_id] {
            let ship = Ship(portShip: unsetShip, rawShip: rawShip)
            Fleet.instance.shipMap[unsetShip.api_id] = ship
            ids.append(unsetShip.api_id)
        }
        Fleet.instance.shipWatcher.onNext(Transform.Change(ids))
    }

}

class SlotDepriveApiData: HandyJSON {

    var api_ship_data: SlotDepriveApiShipData? = SlotDepriveApiShipData()
    var api_unset_list: ApiUnsetList? = ApiUnsetList()

    required init() {

    }

}

class ApiUnsetList: HandyJSON {

    var api_type3No: Int = 0
    var api_slot_list = Array<Int>()

    required init() {

    }

}

class SlotDepriveApiShipData: HandyJSON {

    var api_set_ship: ApiShip? = ApiShip()
    var api_unset_ship: ApiShip? = ApiShip()

    required init() {

    }

}
