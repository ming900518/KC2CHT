//
// Created by CC on 2019-03-16.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import RxSwift
import HandyJSON

class BattleCombinedNight: JsonBean {

    var api_result: Int = 0
    var api_result_msg: String = ""
    var api_data: BattleCombinedNightData? = BattleCombinedNightData()

    override func process() {
        Battle.instance.newTurn()
        Battle.instance.calcTargetDamage(targetList: api_data?.api_friendly_battle?.api_hougeki?.api_df_list,
                damageList: api_data?.api_friendly_battle?.api_hougeki?.api_damage,
                flagList: api_data?.api_friendly_battle?.api_hougeki?.api_at_eflag, enemyOnly: true)
        Battle.instance.calcTargetDamage(targetList: api_data?.api_hougeki?.api_df_list,
                damageList: api_data?.api_hougeki?.api_damage,
                flagList: api_data?.api_hougeki?.api_at_eflag)
        Battle.instance.calcRank()
        Battle.instance.phaseShift(value: Phase.BattleCombinedNight)
    }

}

class BattleCombinedNightData: HandyJSON {

    var api_deck_id: Int = 0
    var api_formation = Array<Int>()
    var api_f_nowhps = Array<Int>()
    var api_f_maxhps = Array<Int>()
    var api_f_nowhps_combined = Array<Int>()
    var api_f_maxhps_combined = Array<Int>()
    var api_fParam = Array<Array<Int>>()
    var api_fParam_combined = Array<Array<Int>>()
    var api_ship_ke = Array<Int>()
    var api_ship_lv = Array<Int>()
    var api_ship_ke_combined = Array<Int>()
    var api_ship_lv_combined = Array<Int>()
    var api_e_nowhps = Array<Int>()
    var api_e_maxhps = Array<Int>()
    var api_e_nowhps_combined = Array<Int>()
    var api_e_maxhps_combined = Array<Int>()
    var api_eSlot = Array<Array<Int>>()
    var api_eSlot_combined = Array<Array<Int>>()
    var api_eParam = Array<Array<Int>>()
    var api_eParam_combined = Array<Array<Int>>()
    var api_friendly_info: ApiFriendlyInfo? = ApiFriendlyInfo()
    var api_friendly_battle: ApiFriendlyBattle? = ApiFriendlyBattle()
    var api_active_deck = Array<Int>()
    var api_touch_plane = Array<Int>()
    var api_flare_pos = Array<Int>()
    var api_hougeki: ApiHougeki? = ApiHougeki()

    required init() {

    }

}

class ApiFriendlyBattle: HandyJSON {

    var api_flare_pos = Array<Int>()
    var api_hougeki: ApiHougeki? = ApiHougeki()

    required init() {

    }

}

class ApiFriendlyInfo: HandyJSON {

    var api_production_type: Int = 0
    var api_ship_id = Array<Int>()
    var api_ship_lv = Array<Int>()
    var api_f_nowhps = Array<Int>()
    var api_f_maxhps = Array<Int>()
    var api_Slot = Array<Array<Int>>()
    var api_Param = Array<Array<Int>>()
    var api_voice_id = Array<Array<Int>>()
    var api_voice_p_no = Array<Array<Int>>()

    required init() {

    }

}
