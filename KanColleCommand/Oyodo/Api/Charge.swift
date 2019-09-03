//
// Created by CC on 2019-03-24.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import HandyJSON
import RxSwift

class Charge: JsonBean {

    var api_result: Int = 0
    var api_result_msg: String = ""
    var api_data: ChargeApiData? = ChargeApiData()

    override func process() {
        if let fuel = api_data?.api_material[safe: 0] {
            Resource.instance.fuel.onNext(fuel)
        }
        if let ammo = api_data?.api_material[safe: 1] {
            Resource.instance.ammo.onNext(ammo)
        }
        if let metal = api_data?.api_material[safe: 2] {
            Resource.instance.metal.onNext(metal)
        }
        if let bauxite = api_data?.api_material[safe: 3] {
            Resource.instance.bauxite.onNext(bauxite)
        }

        var shipIds = Array<Int>()
        api_data?.api_ship.forEach { api in
            if let ship = Fleet.instance.shipMap[safe: api.api_id] {
                shipIds.append(ship.id)
                ship.nowFuel = api.api_fuel
                ship.nowBullet = api.api_bull
                ship.carrys = api.api_onslot
            }
        }
        Fleet.instance.shipWatcher.onNext(Transform.Change(shipIds))

        setMissionProgress(bean: self, type: MissionRequireType.SUPPLY)
    }

}

class ChargeApiData: HandyJSON {
    var api_ship = Array<ChargeApiShip>()
    var api_material = Array<Int>()
    var api_use_bou: Int = 0

    required init() {

    }
}

class ChargeApiShip: HandyJSON {
    var api_id: Int = 0
    var api_fuel: Int = 0
    var api_bull: Int = 0
    var api_onslot = Array<Int>()

    required init() {

    }
}
