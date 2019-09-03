//
// Created by CC on 2019-03-24.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import HandyJSON
import RxSwift

class PresetSelect: JsonBean {

    var api_result: Int = 0
    var api_result_msg: String = ""
    var api_data: PresetSelectData? = PresetSelectData()

    override func process() {
        let index = api_data?.api_id ?? 0
        let ids = api_data?.api_ship
        if (index > 0 && ids?.count != 0) {
            Fleet.instance.deckShipIds[index - 1].onNext(ids!)
        }
    }

}

class PresetSelectData: HandyJSON {

    var api_member_id: Int = 0
    var api_id: Int = 0
    var api_name: String = ""
    var api_name_id: String = ""
    var api_mission = Array<Int>()
    var api_flagship: String = ""
    var api_ship = Array<Int>()

    required init() {

    }

}
