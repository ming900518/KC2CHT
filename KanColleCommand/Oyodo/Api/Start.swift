//
// Created by CC on 2019-02-09.
// Copyright {c} 2019 CC. All rights reserved.
//

import Foundation
import HandyJSON

class Start: JsonBean {

    var api_result: Int?
    var api_result_msg: String?
    var api_data: StartApiData?

    required init() {

    }

    override func process() {
        api_data?.api_mst_ship?.forEach { ship in
            Raw.instance.rawShipMap[ship.api_id!] = ship
        }
        api_data?.api_mst_slotitem?.forEach { slot in
            Raw.instance.rawSlotMap[slot.api_id!] = slot
        }
    }

}

class StartApiData: HandyJSON {

    var api_mst_ship: Array<ApiMstShip>?
    var api_mst_shipgraph: Array<ApiMstShipgraph>?
    var api_mst_slotitem_equiptype: Array<ApiMstSlotitemEquiptype>?
    var api_mst_equip_exslot: Array<Int>?
    var api_mst_equip_exslot_ship: Array<ApiMstEquipExslotShip>?
    var api_mst_stype: Array<ApiMstStype>?
    var api_mst_slotitem: Array<ApiMstSlotitem>?
    var api_mst_furniture: Array<ApiMstFurniture>?
    var api_mst_furnituregraph: Array<ApiMstFurnituregraph>?
    var api_mst_useitem: Array<ApiMstUseitem>?
    var api_mst_payitem: Array<ApiMstPayitem>?
    var api_mst_item_shop: ApiMstItemShop?
    var api_mst_maparea: Array<ApiMstMaparea>?
    var api_mst_mapinfo: Array<ApiMstMapinfo>?
    var api_mst_mapbgm: Array<ApiMstMapbgm>?
    var api_mst_mission: Array<ApiMstMission>?
    var api_mst_const: ApiMstConst?
    var api_mst_shipupgrade: Array<ApiMstShipupgrade>?
    var api_mst_bgm: Array<ApiMstBgm>?

    required init() {

    }
}

class ApiMstUseitem: HandyJSON {
    var api_id: Int?
    var api_usetype: Int?
    var api_category: Int?
    var api_name: String?
    var api_description: Array<String>?
    var api_price: Int?

    required init() {

    }

}

class ApiMstPayitem: HandyJSON {
    var api_id: Int?
    var api_type: Int?
    var api_name: String?
    var api_description: String?
    var api_item: Array<Int>?
    var api_price: Int?

    required init() {

    }

}

class ApiMstStype: HandyJSON {
    var api_id: Int?
    var api_sortno: Int?
    var api_name: String?
    var api_scnt: Int?
    var api_kcnt: Int?
    var api_equip_type: Dictionary<String, String>?

    required init() {

    }

}

class ApiMstBgm: HandyJSON {
    var api_id: Int?
    var api_name: String?

    required init() {

    }

}

class ApiMstFurnituregraph: HandyJSON {
    var api_id: Int?
    var api_type: Int?
    var api_no: Int?
    var api_filename: String?
    var api_version: String?

    required init() {

    }

}

class ApiMstItemShop: HandyJSON {
    var api_cabinet_1: Array<Int>?
    var api_cabinet_2: Array<Int>?

    required init() {

    }

}

class ApiMstMaparea: HandyJSON {
    var api_id: Int?
    var api_name: String?
    var api_type: Int?

    required init() {

    }

}

class ApiMstMapbgm: HandyJSON {
    var api_id: Int?
    var api_maparea_id: Int?
    var api_no: Int?
    var api_moving_bgm: Int?
    var api_map_bgm: Array<Int>?
    var api_boss_bgm: Array<Int>?

    required init() {

    }

}

class ApiMstShipupgrade: HandyJSON {
    var api_id: Int?
    var api_current_ship_id: Int?
    var api_original_ship_id: Int?
    var api_upgrade_type: Int?
    var api_upgrade_level: Int?
    var api_drawing_count: Int?
    var api_catapult_count: Int?
    var api_report_count: Int?
    var api_sortno: Int?

    required init() {

    }

}

class ApiMstMapinfo: HandyJSON {
    var api_id: Int?
    var api_maparea_id: Int?
    var api_no: Int?
    var api_name: String?
    var api_level: Int?
    var api_opetext: String?
    var api_infotext: String?
    var api_item: Array<Int>?
    var api_max_maphp: Any?
    var api_required_defeat_count: Any?
    var api_sally_flag: Array<Int>?

    required init() {

    }

}

class ApiMstShip: HandyJSON {
    var api_id: Int?
    var api_sortno: Int?
    var api_name: String?
    var api_yomi: String?
    var api_stype: Int?
    var api_ctype: Int?
    var api_afterlv: Int?
    var api_aftershipid: String?
    var api_taik: Array<Int>?
    var api_souk: Array<Int>?
    var api_houg: Array<Int>?
    var api_raig: Array<Int>?
    var api_tyku: Array<Int>?
    var api_luck: Array<Int>?
    var api_soku: Int?
    var api_leng: Int?
    var api_slot_num: Int?
    var api_maxeq: Array<Int>?
    var api_buildtime: Int?
    var api_broken: Array<Int>?
    var api_powup: Array<Int>?
    var api_backs: Int?
    var api_getmes: String?
    var api_afterfuel: Int?
    var api_afterbull: Int?
    var api_fuel_max: Int?
    var api_bull_max: Int?
    var api_voicef: Int?

    required init() {

    }

}

class ApiMstFurniture: HandyJSON {
    var api_id: Int?
    var api_type: Int?
    var api_no: Int?
    var api_title: String?
    var api_description: String?
    var api_rarity: Int?
    var api_price: Int?
    var api_saleflg: Int?
    var api_season: Int?

    required init() {

    }

}

class ApiMstSlotitemEquiptype: HandyJSON {
    var api_id: Int?
    var api_name: String?
    var api_show_flg: Int?

    required init() {

    }

}

class ApiMstEquipExslotShip: HandyJSON {
    var api_slotitem_id: Int?
    var api_ship_ids: Array<Int>?

    required init() {

    }

}

class ApiMstSlotitem: HandyJSON {
    var api_id: Int?
    var api_sortno: Int?
    var api_name: String?
    var api_type: Array<Int>?
    var api_taik: Int?
    var api_souk: Int?
    var api_houg: Int?
    var api_raig: Int?
    var api_soku: Int?
    var api_baku: Int?
    var api_tyku: Int?
    var api_tais: Int?
    var api_atap: Int?
    var api_houm: Int?
    var api_raim: Int?
    var api_houk: Int?
    var api_raik: Int?
    var api_bakk: Int?
    var api_saku: Int?
    var api_sakb: Int?
    var api_luck: Int?
    var api_leng: Int?
    var api_rare: Int?
    var api_broken: Array<Int>?
    var api_info: String?
    var api_usebull: String?

    required init() {

    }

}

class ApiMstConst: HandyJSON {
    var api_boko_max_ships: ApiBokoMaxShips?
    var api_parallel_quest_max: ApiParallelQuestMax?
    var api_dpflag_quest: ApiDpflagQuest?

    required init() {

    }

}

class ApiDpflagQuest: HandyJSON {
    var api_string_varue: String?
    var api_int_varue: Int?

    required init() {

    }

}

class ApiParallelQuestMax: HandyJSON {
    var api_string_varue: String?
    var api_int_varue: Int?

    required init() {

    }

}

class ApiBokoMaxShips: HandyJSON {
    var api_string_varue: String?
    var api_int_varue: Int?

    required init() {

    }

}

class ApiMstMission: HandyJSON {
    var api_id: Int?
    var api_disp_no: String?
    var api_maparea_id: Int?
    var api_name: String?
    var api_details: String?
    var api_time: Int?
    var api_deck_num: Int?
    var api_difficulty: Int?
    var api_use_fuel: Double?
    var api_use_bull: Double?
    var api_win_item1: Array<Int>?
    var api_win_item2: Array<Int>?
    var api_return_flag: Int?

    required init() {

    }

}

class ApiMstShipgraph: HandyJSON {
    var api_id: Int?
    var api_sortno: Int?
    var api_filename: String?
    var api_version: Array<String>?
    var api_boko_n: Array<Int>?
    var api_boko_d: Array<Int>?
    var api_kaisyu_n: Array<Int>?
    var api_kaisyu_d: Array<Int>?
    var api_kaizo_n: Array<Int>?
    var api_kaizo_d: Array<Int>?
    var api_map_n: Array<Int>?
    var api_map_d: Array<Int>?
    var api_ensyuf_n: Array<Int>?
    var api_ensyuf_d: Array<Int>?
    var api_ensyue_n: Array<Int>?
    var api_battle_n: Array<Int>?
    var api_battle_d: Array<Int>?
    var api_weda: Array<Int>?
    var api_wedb: Array<Int>?

    required init() {

    }

}