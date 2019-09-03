//
// Created by CC on 2019-03-24.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import HandyJSON
import RxSwift

class SlotItem: JsonBean {

    var api_result: Int = 0
    var api_result_msg: String = ""
    var api_data = Array<ApiSlotItem>()

    override func process() {
        Fleet.instance.slotMap.removeAll()
        api_data.forEach { item in
            let rawSlot = Raw.instance.rawSlotMap[item.api_slotitem_id]
            let slot = Slot(raw: rawSlot, port: item)
            Fleet.instance.slotMap[item.api_id] = slot
        }
        User.instance.slotCount.onNext(Fleet.instance.slotMap.count)
        Fleet.instance.slotWatcher.onNext(Transform.All)
    }

}
