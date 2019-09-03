//
// Created by CC on 2019-03-24.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import HandyJSON
import RxSwift

class CreateItem: JsonBean {

    var api_result: Int = 0
    var api_result_msg: String = ""
    var api_data: CreateItemApiData? = CreateItemApiData()

    override func process() {
        if (api_data?.api_create_flag == 1) {
            let rawSlot = Raw.instance.rawSlotMap[safe: api_data?.api_slot_item?.api_slotitem_id ?? -1]
            let slot = Slot(raw: rawSlot, port: nil)
            let slotId = api_data?.api_slot_item?.api_id ?? -1
            Fleet.instance.slotMap[slotId] = slot
            Fleet.instance.slotWatcher.onNext(Transform.Add(Array(arrayLiteral: slotId)))
            User.instance.slotCount.onNext(Fleet.instance.slotMap.count)
        }
        setMissionProgress(bean: self, type: MissionRequireType.CREATE_ITEM)
    }

}

class CreateItemApiData: HandyJSON {

    var api_create_flag: Int = 0
    var api_shizai_flag: Int = 0
    var api_slot_item: CreateItemApiSlotItem? = CreateItemApiSlotItem()
    var api_material = Array<Int>()
    var api_type3: Int = 0
    var api_unsetslot = Array<Int>()

    required init() {

    }

}

class CreateItemApiSlotItem: HandyJSON {

    var api_id: Int = 0
    var api_slotitem_id: Int = 0

    required init() {

    }

}
