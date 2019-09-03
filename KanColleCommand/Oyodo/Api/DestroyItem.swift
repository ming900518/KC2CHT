//
// Created by CC on 2019-03-24.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import HandyJSON
import RxSwift

class DestroyItem: JsonBean {

    var api_result: Int = 0
    var api_result_msg: String = ""
    var api_data: DestroyItemApiData? = DestroyItemApiData()

    override func process() {
        plusValue(Resource.instance.fuel, api_data?.api_get_material[0])
        plusValue(Resource.instance.ammo, api_data?.api_get_material[1])
        plusValue(Resource.instance.metal, api_data?.api_get_material[2])
        plusValue(Resource.instance.bauxite, api_data?.api_get_material[3])
    }

    private func plusValue(_ material: BehaviorSubject<Int>, _ value: Int?) {
        setMissionProgress(bean: self, type: MissionRequireType.DESTROY_ITEM)

        if let value = value, value > 0 {
            do {
                try material.onNext(material.value() + value)
            } catch {
                print("Got error in DestroyItem plusValue")
            }
        }
        params["api_slotitem_ids"]?
                .components(separatedBy: "%2C")
                .forEach { s in
                    let slotId = parse(value: s)
                    Fleet.instance.slotMap[slotId] = nil
                }
        User.instance.slotCount.onNext(Fleet.instance.slotMap.count)
    }

}

class DestroyItemApiData: HandyJSON {

    var api_get_material = Array<Int>()

    required init() {

    }

}
