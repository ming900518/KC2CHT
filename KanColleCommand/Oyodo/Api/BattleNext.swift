//
// Created by CC on 2019-03-16.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import RxSwift
import HandyJSON

class BattleNext: JsonBean {

    var api_result: Int = 0
    var api_result_msg: String = ""
    var api_data: BattleNextApiData? = BattleNextApiData()

    override func process() {
        Battle.instance.route = api_data?.api_no ?? -1
        Battle.instance.nodeType = api_data?.api_color_no ?? -1
        Battle.instance.friendFormation = -1
        Battle.instance.enemyFormation = -1
        Battle.instance.enemyList.removeAll()
        Battle.instance.airCommand = -1
        Battle.instance.heading = -1
        Battle.instance.rank = ""
        Battle.instance.get = ""

        Battle.instance.finishBattle()

        Battle.instance.phaseShift(value: Phase.Next)
    }

}

class BattleNextApiData: HandyJSON {

    var api_rashin_flg: Int = 0
    var api_rashin_id: Int = 0
    var api_maparea_id: Int = 0
    var api_mapinfo_no: Int = 0
    var api_no: Int = 0
    var api_color_no: Int = 0
    var api_event_id: Int = 0
    var api_event_kind: Int = 0
    var api_next: Int = 0
    var api_bosscell_no: Int = 0
    var api_bosscomp: Int = 0
    var api_comment_kind: Int = 0
    var api_production_kind: Int = 0
    var api_airsearch: ApiAirsearch? = ApiAirsearch()

    required init() {

    }

}