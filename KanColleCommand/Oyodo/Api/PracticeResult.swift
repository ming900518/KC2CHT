//
// Created by CC on 2019-03-16.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import RxSwift
import HandyJSON

class PracticeResult: JsonBean {

    var api_result: Int = 0
    var api_result_msg: String = ""
    var api_data: PracticeResultApiData? = PracticeResultApiData()

    override func process() {
        if let rank = api_data?.api_win_rank {
            Battle.instance.rank = rank
        }
        Battle.instance.phaseShift(value: Phase.PracticeResult)

        setMissionProgress(bean: self, type: MissionRequireType.PRACTICE)
    }

}

class PracticeResultApiData: HandyJSON {

    var api_ship_id = Array<Int>()
    var api_win_rank: String?
    var api_get_exp: Int = 0
    var api_member_lv: Int = 0
    var api_member_exp: Int = 0
    var api_get_base_exp: Int = 0
    var api_mvp: Int = 0
    var api_get_ship_exp = Array<Int>()
    var api_get_exp_lvup = Array<Array<Int>>()
    var api_enemy_info: ApiEnemyInfo? = ApiEnemyInfo()

    required init() {

    }

}
