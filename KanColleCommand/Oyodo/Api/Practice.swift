//
// Created by CC on 2019-03-10.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import HandyJSON
import RxSwift

class Practice: JsonBean {

    var api_result: Int = 0
    var api_result_msg: String = ""
    var api_data: PracticeApiData? = PracticeApiData()

    override func process() {
        Battle.instance.friendIndex = (api_data?.api_deck_id ?? 0) - 1
        Battle.instance.friendFormation = api_data?.api_formation[0] ?? -1
        Battle.instance.enemyFormation = api_data?.api_formation[1] ?? -1
        Battle.instance.heading = api_data?.api_formation[2] ?? -1
        Battle.instance.airCommand = api_data?.api_kouku?.api_stage1?.api_disp_seiku ?? -1

        var enemies = Array<Ship>()
        if let list = api_data?.api_ship_ke {
            for (index, id) in list.enumerated() {
                if let rawShip = Raw.instance.rawShipMap[id] {
                    let enemy = Ship(rawShip: rawShip)
                    enemy.level = api_data?.api_ship_lv[safe: index] ?? 0
                    enemy.nowHp = api_data?.api_e_nowhps[safe: index] ?? 0
                    enemy.maxHp = api_data?.api_e_maxhps[safe: index] ?? 0
                    if let slots = api_data?.api_eSlot[safe: index] {
                        enemy.items.append(contentsOf: slots)
                    }
                    enemies.append(enemy)
                }
            }
        }
        Battle.instance.enemyList = enemies

        Battle.instance.newTurn()

        Battle.instance.calcFriendOrdinalDamage(damageList: api_data?.api_kouku?.api_stage3?.api_fdam)
        Battle.instance.calcEnemyOrdinalDamage(damageList: api_data?.api_kouku?.api_stage3?.api_edam)

        Battle.instance.calcTargetDamage(targetList: api_data?.api_opening_taisen?.api_df_list,
                damageList: api_data?.api_opening_taisen?.api_damage,
                flagList: api_data?.api_opening_taisen?.api_at_eflag)
        Battle.instance.calcFriendOrdinalDamage(damageList: api_data?.api_opening_atack?.api_fdam)
        Battle.instance.calcEnemyOrdinalDamage(damageList: api_data?.api_opening_atack?.api_edam)
        Battle.instance.calcTargetDamage(targetList: api_data?.api_hougeki1?.api_df_list,
                damageList: api_data?.api_hougeki1?.api_damage,
                flagList: api_data?.api_hougeki1?.api_at_eflag)
        Battle.instance.calcTargetDamage(targetList: api_data?.api_hougeki2?.api_df_list,
                damageList: api_data?.api_hougeki2?.api_damage,
                flagList: api_data?.api_hougeki2?.api_at_eflag)
        Battle.instance.calcTargetDamage(targetList: api_data?.api_hougeki3?.api_df_list,
                damageList: api_data?.api_hougeki3?.api_damage,
                flagList: api_data?.api_hougeki3?.api_at_eflag)
        Battle.instance.calcFriendOrdinalDamage(damageList: api_data?.api_raigeki?.api_fdam)
        Battle.instance.calcEnemyOrdinalDamage(damageList: api_data?.api_raigeki?.api_edam)

        Battle.instance.calcRank()

        Battle.instance.phaseShift(value: Phase.Practice)

        Fleet.instance.shipWatcher.onNext(Transform.All)
    }
}

class PracticeApiData: HandyJSON {

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
    var api_midnight_flag: Int = 0
    var api_search = Array<Int>()
    var api_stage_flag = Array<Int>()
    var api_kouku: ApiKouku? = ApiKouku()
    var api_opening_taisen_flag: Int = 0
    var api_opening_taisen: ApiOpeningTaisen? = ApiOpeningTaisen()
    var api_opening_flag: Int = 0
    var api_opening_atack: ApiOpeningAtack? = ApiOpeningAtack()
    var api_hourai_flag = Array<Int>()
    var api_hougeki1: ApiHougeki? = ApiHougeki()
    var api_hougeki2: ApiHougeki? = ApiHougeki()
    var api_hougeki3: ApiHougeki? = ApiHougeki()
    var api_raigeki: ApiRaigeki? = ApiRaigeki()

    required init() {

    }

}
