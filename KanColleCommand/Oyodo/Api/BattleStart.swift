//
// Created by CC on 2019-03-10.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import HandyJSON
import RxSwift

class BattleStart: JsonBean {

    var api_result: Int?
    var api_result_msg: String?
    var api_data: BattleStartApiData?

    required init() {

    }

    override func process() {
        Battle.instance.area = api_data?.api_maparea_id ?? -1
        Battle.instance.map = api_data?.api_mapinfo_no ?? -1
        Battle.instance.route = api_data?.api_no ?? -1
        Battle.instance.nodeType = api_data?.api_color_no ?? -1
        Battle.instance.friendIndex = (Int(params["api_deck_id"] ?? "0") ?? 0) - 1

        Battle.instance.phaseShift(value: Phase.Start)
        Fleet.instance.shipWatcher.onNext(Transform.All)
    }

}

class BattleStartApiData: HandyJSON {

    var api_cell_data = Array<ApiCellData>()
    var api_rashin_flg: Int = 0
    var api_rashin_id: Int = 0
    var api_maparea_id: Int = -1
    var api_mapinfo_no: Int = -1
    var api_no: Int = -1
    var api_color_no: Int = 0
    var api_event_id: Int = 0
    var api_event_kind: Int = 0
    var api_next: Int = 0
    var api_bosscell_no: Int = 0
    var api_bosscomp: Int = 0
    var api_airsearch: ApiAirsearch? = ApiAirsearch()
    var api_from_no: Int = -1

    required init() {

    }

}

class ApiCellData: HandyJSON {

    var api_id: Int = 0
    var api_no: Int = 0
    var api_color_no: Int = 0
    var api_passed: Int = 0

    required init() {

    }

}

class ApiAirsearch: HandyJSON {

    var api_plane_type: Int = 0
    var api_result: Int = 0

    required init() {

    }

}
