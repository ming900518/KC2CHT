//
// Created by CC on 2019-03-16.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import RxSwift
import HandyJSON

class PracticeNight: JsonBean {

    var api_result: Int = 0
    var api_result_msg: String = ""
    var api_data: PracticeNightApiData? = PracticeNightApiData()

    override func process() {
        Battle.instance.newTurn()
        Battle.instance.calcTargetDamage(targetList: api_data?.api_hougeki?.api_df_list,
                damageList: api_data?.api_hougeki?.api_damage,
                flagList: api_data?.api_hougeki?.api_at_eflag)
        Battle.instance.calcRank()
        Battle.instance.phaseShift(value: Phase.PracticeNight)
    }

}

class PracticeNightApiData: HandyJSON {

    var api_deck_id: Int = 0
    var api_formation = Array<Int>()
    var api_f_nowhps = Array<Int>()
    var api_f_maxhps = Array<Int>()
    var api_fParam = Array<Array<Int>>()
    var api_ship_ke = Array<Int>()
    var api_ship_lv = Array<Int>()
    var api_e_nowhps = Array<Int>()
    var api_e_maxhps = Array<Int>()
    var api_eSlot = Array<Array<Int>>()
    var api_eParam = Array<Array<Int>>()
    var api_touch_plane = Array<Int>()
    var api_flare_pos = Array<Int>()
    var api_hougeki: ApiHougeki? = ApiHougeki()

    required init() {

    }

}