//
// Created by CC on 2019-02-10.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import RxSwift
import HandyJSON

class Port: JsonBean {

    var api_result: Int?
    var api_result_msg: String?
    var api_data: PortApiData?

    required init() {

    }

    override func process() {
        // api_material
        Resource.instance.fuel.onNext(api_data?.api_material?[0].api_value ?? 0)
        Resource.instance.ammo.onNext(api_data?.api_material?[1].api_value ?? 0)
        Resource.instance.metal.onNext(api_data?.api_material?[2].api_value ?? 0)
        Resource.instance.bauxite.onNext(api_data?.api_material?[3].api_value ?? 0)
        Resource.instance.burner.onNext(api_data?.api_material?[4].api_value ?? 0)
        Resource.instance.bucket.onNext(api_data?.api_material?[5].api_value ?? 0)
        Resource.instance.research.onNext(api_data?.api_material?[6].api_value ?? 0)
        Resource.instance.improve.onNext(api_data?.api_material?[7].api_value ?? 0)
        // api_basic
        User.instance.nickname.onNext(api_data?.api_basic.api_nickname ?? "")
        User.instance.level.onNext(api_data?.api_basic.api_level ?? 0)
        User.instance.shipMax.onNext(api_data?.api_basic.api_max_chara ?? 0)
        User.instance.slotMax.onNext(api_data?.api_basic.api_max_slotitem ?? 0)
        User.instance.kDockCount.onNext(api_data?.api_basic.api_count_kdock ?? 0)
        User.instance.nDockCount.onNext(api_data?.api_basic.api_count_ndock ?? 0)
        User.instance.deckCount.onNext(api_data?.api_basic.api_count_deck ?? 0)
        // api_ship
        Fleet.instance.shipMap.removeAll()
        api_data?.api_ship?.forEach { it in
            if let rawShip = Raw.instance.rawShipMap[it.api_ship_id] {
                let ship = Ship(portShip: it, rawShip: rawShip)
                Fleet.instance.shipMap[it.api_id] = ship
            }
        }
        Fleet.instance.lastUpdate = Int64(Date().timeIntervalSince1970)
        User.instance.shipCount.onNext(Fleet.instance.shipMap.count)
        // api_deck_port
        if let list = api_data?.api_deck_port {
            for (index, item) in list.enumerated() {
                Fleet.instance.deckShipIds[index].onNext(item.api_ship ?? Array<Int>())
                Fleet.instance.deckNames[index].onNext(item.api_name)
                Dock.instance.expeditionList[index].onNext(Expedition(entity: item))
            }
        }
        // api_ndock
        if let list = api_data?.api_ndock {
            for (index, item) in list.enumerated() {
                Dock.instance.repairList[index].onNext(Repair(entity: item))
            }
        }

        Battle.instance.clear()
        Battle.instance.phaseShift(value: .Idle)
        Battle.instance.friendCombined = (api_data?.api_combined_flag ?? 0) > 0

        Fleet.instance.shipWatcher.onNext(Transform.All)
    }

}

class PortApiData: HandyJSON {
    var api_material: Array<ApiMaterial>?
    var api_deck_port: Array<ApiDeckPort>?
    var api_ndock: Array<ApiNdock>?
    var api_ship: Array<ApiShip>?
    var api_basic: ApiBasic = ApiBasic()
    var api_log: Array<ApiLog>?
    var api_p_bgm_id: Int = 0
    var api_parallel_quest_count: Int = 0
    var api_combined_flag: Int = 0
    var api_dest_ship_slot: Int = 0
    var api_event_object: ApiEventObj = ApiEventObj()

    required init() {

    }
}

class ApiLog: HandyJSON {
    var api_no: Int = 0
    var api_type: String = ""
    var api_state: String = ""
    var api_message: String = ""

    required init() {

    }
}

class ApiNdock: HandyJSON {
    var api_member_id: Int = 0
    var api_id: Int = 0
    var api_state: Int = 0
    var api_ship_id: Int = 0
    var api_complete_time: Int64 = 0
    var api_complete_time_str: String = ""
    var api_item1: Int = 0
    var api_item2: Int = 0
    var api_item3: Int = 0
    var api_item4: Int = 0

    required init() {

    }
}

class ApiShip: HandyJSON {
    var api_id: Int = 0
    var api_sortno: Int = 0
    var api_ship_id: Int = 0
    var api_lv: Int = 0
    var api_exp: Array<Int>?
    var api_nowhp: Int = 0
    var api_maxhp: Int = 0
    var api_soku: Int = 0
    var api_leng: Int = 0
    var api_slot: Array<Int>?
    var api_onslot: Array<Int>?
    var api_slot_ex: Int = 0
    var api_kyouka: Array<Int>?
    var api_backs: Int = 0
    var api_fuel: Int = 0
    var api_bull: Int = 0
    var api_slotnum: Int = 0
    var api_ndock_time: Int = 0
    var api_ndock_item: Array<Int>?
    var api_srate: Int = 0
    var api_cond: Int = 0
    var api_karyoku: Array<Int>?
    var api_raisou: Array<Int>?
    var api_taiku: Array<Int>?
    var api_soukou: Array<Int>?
    var api_kaihi: Array<Int>?
    var api_taisen: Array<Int>?
    var api_sakuteki: Array<Int>?
    var api_lucky: Array<Int>?
    var api_locked: Int = 0
    var api_locked_equip: Int = 0

    required init() {

    }
}

class ApiMaterial: HandyJSON {
    var api_member_id: Int = 0
    var api_id: Int = 0
    var api_value: Int = 0

    required init() {

    }
}

class ApiDeckPort: HandyJSON {
    var api_member_id: Int = 0
    var api_id: Int = 0
    var api_name: String = ""
    var api_name_id: String = ""
    var api_mission: Array<String>?
    var api_flagship: String = ""
    var api_ship: Array<Int>?

    required init() {

    }
}

class ApiBasic: HandyJSON {
    var api_member_id: String = ""
    var api_nickname: String = ""
    var api_nickname_id: String = ""
    var api_active_flag: Int = 0
    var api_starttime: Int64 = 0
    var api_level: Int = 0
    var api_rank: Int = 0
    var api_experience: Int = 0
    var api_comment: String = ""
    var api_comment_id: String = ""
    var api_max_chara: Int = 0
    var api_max_slotitem: Int = 0
    var api_max_kagu: Int = 0
    var api_playtime: Int64 = 0
    var api_tutorial: Int = 0
    var api_furniture: Array<Int>?
    var api_count_deck: Int = 0
    var api_count_kdock: Int = 0
    var api_count_ndock: Int = 0
    var api_fcoin: Int = 0
    var api_st_win: Int = 0
    var api_st_lose: Int = 0
    var api_ms_count: Int = 0
    var api_ms_success: Int = 0
    var api_pt_win: Int = 0
    var api_pt_lose: Int = 0
    var api_pt_challenged: Int = 0
    var api_pt_challenged_win: Int = 0
    var api_firstflag: Int = 0
    var api_tutorial_progress: Int = 0
    var api_pvp: Array<Int>?
    var api_medals: Int = 0
    var api_large_dock: Int = 0

    required init() {

    }
}

class ApiEventObj: HandyJSON {
    var api_m_flag: Int = 0
    var api_c_num: Int = 0
        
    required init(){
            
    }
}
