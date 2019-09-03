//
// Created by CC on 2019-03-24.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import HandyJSON

class BattleNightSp: JsonBean {

    var api_result: Int = 0
    var api_result_msg: String = ""
    var api_data: BattleNightSpApiData? = BattleNightSpApiData()

    override func process() {
        Battle.instance.friendFormation = api_data?.api_formation[0] ?? -1
        Battle.instance.enemyFormation = api_data?.api_formation[1] ?? -1
        Battle.instance.heading = api_data?.api_formation[2] ?? -1

        var enemies = Array<Ship>()
        if let data = api_data {
            for (index, id) in data.api_ship_ke.enumerated() {
                if let rawShip = Raw.instance.rawShipMap[id] {
                    let enemy = Ship(rawShip: rawShip)
                    enemy.level = data.api_ship_lv[index]
                    enemy.nowHp = data.api_e_nowhps[index]
                    enemy.maxHp = data.api_e_maxhps[index]
                    enemy.items.append(contentsOf: data.api_eSlot[index])
                    enemies.append(enemy)
                }
            }
        }
        Battle.instance.enemyList = enemies

        Battle.instance.newTurn()
        Battle.instance.calcEnemyOrdinalDamage(damageList: api_data?.api_n_support_info?.api_support_hourai?.api_damage)
        Battle.instance.calcTargetDamage(targetList: api_data?.api_hougeki?.api_df_list,
                damageList: api_data?.api_hougeki?.api_damage,
                flagList: api_data?.api_hougeki?.api_at_eflag)
        Battle.instance.calcRank()

        Battle.instance.phaseShift(value: .BattleNightSp)
    }

}

class BattleNightSpApiData: HandyJSON {

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
    var api_n_support_flag: Int = 0
    var api_n_support_info: ApiNSupportInfo? = ApiNSupportInfo()
    var api_touch_plane = Array<Int>()
    var api_flare_pos = Array<Int>()
    var api_hougeki: ApiHougeki? = ApiHougeki()

    required init() {

    }

}

class ApiNSupportInfo: HandyJSON {

    var api_support_hourai: ApiSupportHourai? = ApiSupportHourai()

    required init() {

    }

}
