//
// Created by CC on 2019-03-10.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import HandyJSON

class BattleDaytime: JsonBean {

    var api_result: Int = 0
    var api_result_msg: String = ""
    var api_data: BattleApiData? = BattleApiData()

    override func process() {
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
        Battle.instance.calcFriendOrdinalDamage(damageList: api_data?.api_air_base_injection?.api_stage3?.api_fdam)
        Battle.instance.calcEnemyOrdinalDamage(damageList: api_data?.api_air_base_injection?.api_stage3?.api_edam)
        Battle.instance.calcFriendOrdinalDamage(damageList: api_data?.api_injection_kouku?.api_stage3?.api_fdam)
        Battle.instance.calcEnemyOrdinalDamage(damageList: api_data?.api_injection_kouku?.api_stage3?.api_edam)
        api_data?.api_air_base_attack.forEach { it in
            Battle.instance.calcFriendOrdinalDamage(damageList: it.api_stage3?.api_fdam)
            Battle.instance.calcEnemyOrdinalDamage(damageList: it.api_stage3?.api_edam)
        }

        Battle.instance.calcEnemyOrdinalDamage(damageList: api_data?.api_support_info?.api_support_airattack?.api_stage3?.api_edam)
        Battle.instance.calcEnemyOrdinalDamage(damageList: api_data?.api_support_info?.api_support_hourai?.api_damage)

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

        Battle.instance.phaseShift(value: Phase.BattleDaytime)
    }
}

class BattleApiData: HandyJSON {

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
    var api_support_flag: Int = 0
    var api_support_info: ApiSupportInfo? = ApiSupportInfo()
    var api_opening_taisen_flag: Int = 0
    var api_opening_taisen: ApiOpeningTaisen? = ApiOpeningTaisen()
    var api_opening_flag: Int = 0
    var api_opening_atack: ApiOpeningAtack? = ApiOpeningAtack()
    var api_hourai_flag = Array<Int>()
    var api_hougeki1: ApiHougeki? = ApiHougeki()
    var api_hougeki2: ApiHougeki? = ApiHougeki()
    var api_hougeki3: ApiHougeki? = ApiHougeki()
    var api_raigeki: ApiRaigeki? = ApiRaigeki()
    var api_air_base_injection: ApiAirBaseInjection? = ApiAirBaseInjection()
    var api_injection_kouku: ApiInjectionKouku? = ApiInjectionKouku()
    var api_air_base_attack = Array<ApiAirBaseAttack>()

    required init() {

    }

}

class ApiHougeki: HandyJSON {

    var api_at_eflag = Array<Int>()
    var api_at_list = Array<Any>()
    var api_at_type = Array<Any>()
    var api_df_list = Array<Any>()
    var api_si_list = Array<Any>()
    var api_cl_list = Array<Any>()
    var api_damage = Array<Any>()

    required init() {

    }

}

class ApiKouku: HandyJSON {

    var api_stage3: ApiStage3? = ApiStage3()
    var api_stage1: ApiStage1? = ApiStage1()

    required init() {

    }

}

class ApiStage2: HandyJSON {

    var api_f_count: Int = 0
    var api_f_lostcount: Int = 0
    var api_e_count: Int = 0
    var api_e_lostcount: Int = 0

    required init() {

    }

}

class ApiStage3: HandyJSON {

    var api_fdam = Array<Double>()
    var api_edam = Array<Double>()

    required init() {

    }

}

class ApiStage1: HandyJSON {

    var api_f_count: Int = 0
    var api_f_lostcount: Int = 0
    var api_e_count: Int = 0
    var api_e_lostcount: Int = 0
    var api_disp_seiku: Int = 0
    var api_touch_plane = Array<Int>()

    required init() {

    }

}

class ApiSupportInfo: HandyJSON {

    var api_support_airattack: ApiSupportAirAttack? = ApiSupportAirAttack()
    var api_support_hourai: ApiSupportHourai? = ApiSupportHourai()

    required init() {

    }

}

class ApiSupportAirAttack: HandyJSON {

    var api_stage3: ApiStage3? = ApiStage3()

    required init() {

    }

}

class ApiSupportHourai: HandyJSON {

    var api_damage = Array<Double>()

    required init() {

    }

}

class ApiOpeningTaisen: HandyJSON {

    var api_at_eflag = Array<Int>()
    var api_df_list = Array<Any>()
    var api_damage = Array<Any>()

    required init() {

    }

}

class ApiOpeningAtack: HandyJSON {

    var api_fdam = Array<Double>()
    var api_edam = Array<Double>()

    required init() {

    }

}

class ApiRaigeki: HandyJSON {

    var api_fdam = Array<Double>()
    var api_edam = Array<Double>()

    required init() {

    }

}

class ApiAirBaseInjection: HandyJSON {

    var api_stage3: ApiStage3? = ApiStage3()

    required init() {

    }

}

class ApiInjectionKouku: HandyJSON {

    var api_stage3: ApiStage3? = ApiStage3()

    required init() {

    }

}

class ApiAirBaseAttack: HandyJSON {

    var api_stage3: ApiStage3? = ApiStage3()

    required init() {

    }

}
