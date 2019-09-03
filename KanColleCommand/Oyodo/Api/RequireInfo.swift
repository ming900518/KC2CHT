//
// Created by CC on 2019-02-09.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import HandyJSON
import RxSwift

class RequireInfo: JsonBean {

    var api_result: Int = 0
    var api_result_msg: String = ""
    var api_data: RequireInfoApiData?

    required init() {

    }

    override func process() {
        Fleet.instance.slotMap.removeAll()
        api_data?.api_slot_item?.forEach { item in
            let rawSlot = Raw.instance.rawSlotMap[item.api_slotitem_id]
            let slot = Slot(raw: rawSlot, port: item)
            Fleet.instance.slotMap[item.api_id] = slot
        }
        Fleet.instance.slotWatcher.onNext(Transform.All)
        User.instance.slotCount.onNext(Fleet.instance.slotMap.count)
    }
}

class RequireInfoApiData: HandyJSON {
    var api_basic: RequireInfoApiBasic?
    var api_slot_item: Array<ApiSlotItem>?
    var api_unsetslot: Dictionary<String, Array<Int>>?
    var api_kdock: Array<Any>?
    var api_useitem: Array<ApiUseitem>?
    var api_furniture: Array<ApiFurniture>?
    var api_extra_supply: Array<Int>?

    required init() {

    }
}

class ApiFurniture: HandyJSON {
    var api_id: Int = 0
    var api_furniture_type: Int = 0
    var api_furniture_no: Int = 0
    var api_furniture_id: Int = 0

    required init() {

    }
}

class ApiUseitem: HandyJSON {
    var api_id: Int = 0
    var api_count: Int = 0

    required init() {

    }
}

class ApiSlotItem: HandyJSON {
    var api_id: Int = 0
    var api_slotitem_id: Int = 0
    var api_locked: Int = 0
    var api_level: Int = 0
    var api_alv: Int = 0

    required init() {

    }
}

class RequireInfoApiBasic: HandyJSON {
    var api_member_id: Int = 0
    var api_firstflag: Int = 0

    required init() {

    }
}
