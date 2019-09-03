//
// Created by CC on 2019-03-24.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation

class BattleAir: JsonBean {

    var api_result: Int = 0
    var api_result_msg: String = ""
    var api_data: BattleApiData? = BattleApiData()

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

        Battle.instance.calcAirRank()

        Battle.instance.phaseShift(value: .BattleAir)
    }

}
