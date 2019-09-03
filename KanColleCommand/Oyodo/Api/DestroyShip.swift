//
// Created by CC on 2019-03-24.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import HandyJSON
import RxSwift

class DestroyShip: JsonBean {

    var api_result: Int = 0
    var api_result_msg: String = ""
    var api_data: DestroyItemApiData? = DestroyItemApiData()

    override func process() {
        let slotDestroy = params["api_slot_dest_flag"] == "1"
        let shipIds = params["api_ship_id"]?.components(separatedBy: ",")
        var slotIds = Array<Int>()
        shipIds?.forEach { shipId in
            let id = parse(value: shipId)
            let ship = Fleet.instance.shipMap[id]
            Fleet.instance.shipMap.removeValue(forKey: id)
            if (slotDestroy) {
                ship?.items.forEach { itemId in
                    Fleet.instance.slotMap.removeValue(forKey: itemId)
                    slotIds.append(itemId)
                }
            }
            Fleet.instance.deckShipIds.forEach { subject in
                do {
                    let ids = try subject.value().filter { (i: Int) -> Bool in
                        i != id
                    }
                    subject.onNext(ids)
                } catch {
                    print("Got error in DestroyItem plusValue")
                }
            }
        }
        if let ids = (shipIds?.map { s -> Int in
            parse(value: s)
        }) {
            Fleet.instance.shipWatcher.onNext(Transform.Remove(ids))
        }
        User.instance.shipCount.onNext(Fleet.instance.shipMap.count)
        Fleet.instance.slotWatcher.onNext(Transform.Remove(slotIds))
        User.instance.slotCount.onNext(Fleet.instance.slotMap.count)

        setMissionProgress(bean: self, type: MissionRequireType.DESTROY_SHIP)
    }

}

class DestroyShipApiData: HandyJSON {

    var api_get_material = Array<Int>()

    required init() {

    }

}
