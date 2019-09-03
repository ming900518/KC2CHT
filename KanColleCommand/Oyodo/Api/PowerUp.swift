//
// Created by CC on 2019-03-24.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import HandyJSON
import RxSwift

class PowerUp: JsonBean {

    var api_result: Int = 0
    var api_result_msg: String = ""
    var api_data: PowerUpApiData? = PowerUpApiData()

    override func process() {
        if (api_data?.api_powerup_flag == 1) {
            var slotIds = Array<Int>()
            if let shipIds = params["api_id_items"]?.components(separatedBy: "%2C") {
                shipIds.forEach { s in
                    if let ship = Fleet.instance.shipMap[parse(value: s)] {
                        ship.items.forEach { itemId in
                            Fleet.instance.slotMap.removeValue(forKey: itemId)
                            slotIds.append(itemId)
                        }
                        Fleet.instance.shipMap.removeValue(forKey: ship.id)
                    }
                }
                Fleet.instance.shipWatcher.onNext(Transform.Remove(shipIds.map { id -> Int in
                    parse(value: id)
                }))
                Fleet.instance.slotWatcher.onNext(Transform.Remove(slotIds))
            }
            if let apiShip = api_data?.api_ship, let rawShip = Raw.instance.rawShipMap[apiShip.api_ship_id] {
                let ship = Ship(portShip: apiShip, rawShip: rawShip)
                Fleet.instance.shipMap[ship.id] = ship
                Fleet.instance.shipWatcher.onNext(Transform.Change(Array(arrayLiteral: ship.id)))
                User.instance.shipCount.onNext(Fleet.instance.shipMap.count)
                User.instance.slotCount.onNext(Fleet.instance.slotMap.count)
            }
        }

        setMissionProgress(bean: self, type: MissionRequireType.POWER_UP)
    }

}

class PowerUpApiData: HandyJSON {

    var api_powerup_flag: Int = 0
    var api_ship: ApiShip = ApiShip()
    var api_deck = Array<ApiDeck>()

    required init() {

    }

}

class ApiDeck: HandyJSON {

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
