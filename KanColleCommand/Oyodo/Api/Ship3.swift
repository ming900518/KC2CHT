//
// Created by CC on 2019-03-24.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import HandyJSON
import RxSwift

class Ship3: JsonBean {

    var api_result: Int = 0
    var api_result_msg: String = ""
    var api_data: Ship3ApiData? = Ship3ApiData()

    override func process() {
        api_data?.api_ship_data.forEach { apiShip in
            if let rawShip = Raw.instance.rawShipMap[apiShip.api_ship_id] {
                let ship = Ship(apiShip: apiShip, rawShip: rawShip)
                Fleet.instance.shipMap[apiShip.api_id] = ship
//                apiShip.api_slot.forEach { slotId in
//                    let rawSlot = Raw.instance.rawSlotMap[slotId]
//                    let slot = Slot(raw: rawSlot)
//                    Fleet.instance.slotMap[]
//                }
            }
        }
        if let ids = (api_data?.api_ship_data.map { data -> Int in
            data.api_id
        }) {
            Fleet.instance.shipWatcher.onNext(Transform.Add(ids))
        }
        api_data?.api_deck_data.forEach { data in
            let fleetIds = data.api_ship
            Fleet.instance.deckShipIds[data.api_id - 1].onNext(fleetIds)
        }
    }

}

class Ship3ApiData: HandyJSON {

    var api_ship_data = Array<ApiShipData>()
    var api_deck_data = Array<ApiDeckData>()
    var api_slot_data = Dictionary<String, Array<Int>>()

    required init() {

    }

}

class ApiShipData: HandyJSON {

    var api_id: Int = 0
    var api_sortno: Int = 0
    var api_ship_id: Int = 0
    var api_lv: Int = 0
    var api_exp = Array<Int>()
    var api_nowhp: Int = 0
    var api_maxhp: Int = 0
    var api_soku: Int = 0
    var api_leng: Int = 0
    var api_slot = Array<Int>()
    var api_onslot = Array<Int>()
    var api_slot_ex: Int = 0
    var api_kyouka = Array<Int>()
    var api_backs: Int = 0
    var api_fuel: Int = 0
    var api_bull: Int = 0
    var api_slotnum: Int = 0
    var api_ndock_time: Int64 = 0
    var api_ndock_item = Array<Int>()
    var api_srate: Int = 0
    var api_cond: Int = 0
    var api_karyoku = Array<Int>()
    var api_raisou = Array<Int>()
    var api_taiku = Array<Int>()
    var api_soukou = Array<Int>()
    var api_kaihi = Array<Int>()
    var api_taisen = Array<Int>()
    var api_sakuteki = Array<Int>()
    var api_lucky = Array<Int>()
    var api_locked: Int = 0
    var api_locked_equip: Int = 0
    var api_sally_area: Int = 0

    required init() {

    }

}

class ApiDeckData: HandyJSON {

    var api_member_id: Int = 0
    var api_id: Int = 0
    var api_name: String = ""
    var api_name_id: String = ""
    var api_mission = Array<String>()
    var api_flagship: String = ""
    var api_ship = Array<Int>()

    required init() {

    }

}
