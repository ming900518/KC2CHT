//
// Created by CC on 2019-03-24.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import HandyJSON
import RxSwift

class MissionResult: JsonBean {

    var api_result: Int = 0
    var api_result_msg: String = ""
    var api_data: MissionResultData? = MissionResultData()

    override func process() {
        setMissionProgress(bean: self, type: MissionRequireType.EXPEDITION)
    }

}

class MissionResultData: HandyJSON {

    var api_ship_id = Array<Int>()
    var api_clear_result: Int = 0
    var api_get_exp: Int = 0
    var api_member_lv: Int = 0
    var api_member_exp: Int = 0
    var api_get_ship_exp = Array<Int>()
    var api_get_exp_lvup = Array<Array<Int>>()
    var api_maparea_name: String = ""
    var api_detail: String = ""
    var api_quest_name: String = ""
    var api_quest_level: Int = 0
    var api_get_material = Array<Int>()
    var api_useitem_flag = Array<Int>()

    required init() {

    }

}
