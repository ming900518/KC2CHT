//
// Created by CC on 2019-03-24.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import HandyJSON
import RxSwift

class SlotExchangeIndex: JsonBean {

    var api_result: Int = 0
    var api_result_msg: String = ""
    var api_data: SlotExchangeIndexApiData? = SlotExchangeIndexApiData()

    override func process() {
        let shipId = parse(value: params["api_id"])
        if let ship = Fleet.instance.shipMap[shipId] {
            if let items = api_data?.api_slot {
                ship.items = items
            }
            Fleet.instance.shipWatcher.onNext(Transform.Change(Array(arrayLiteral: ship.id)))
        }
    }

}

class SlotExchangeIndexApiData: HandyJSON {

    var api_slot = Array<Int>()

    required init() {

    }

}
