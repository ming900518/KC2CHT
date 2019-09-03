//
// Created by CC on 2019-02-09.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import RxSwift
import HandyJSON

class Oyodo {

    private static let sharedInstance = Oyodo()

    private init() {
    }

    public class func attention() -> Oyodo {
        return sharedInstance
    }

    public func api(url: String, request: String, response: String) {
        var bean: JsonBean? = nil
        if (url.hasSuffix("api_req_air_corps/supply")) {
            //bean = AirBaseSupply.deserialize(from: response)
        } else if (url.hasSuffix("api_req_sortie/ld_airbattle")) {
            bean = BattleAir.deserialize(from: response)
        } else if (url.hasSuffix("api_req_combined_battle/battle")) {
            bean = BattleCombined.deserialize(from: response)
        } else if (url.hasSuffix("api_req_combined_battle/ld_airbattle")) {
            bean = BattleCombinedAir.deserialize(from: response)
        } else if (url.hasSuffix("api_req_combined_battle/each_battle")) {
            bean = BattleCombinedEach.deserialize(from: response)
        } else if (url.hasSuffix("api_req_combined_battle/ec_battle")) {
            bean = BattleCombinedEc.deserialize(from: response)
        } else if (url.hasSuffix("api_req_combined_battle/ec_midnight_battle")) {
            bean = BattleCombinedNight.deserialize(from: response)
        } else if (url.hasSuffix("api_req_combined_battle/battleresult")) {
            bean = BattleCombinedResult.deserialize(from: response)
        } else if (url.hasSuffix("api_req_combined_battle/battle_water")) {
            bean = BattleCombinedWater.deserialize(from: response)
        } else if (url.hasSuffix("api_req_combined_battle/each_battle_water")) {
            bean = BattleCombinedWaterEach.deserialize(from: response)
        } else if (url.hasSuffix("api_req_sortie/battle")) {
            bean = BattleDaytime.deserialize(from: response)
        } else if (url.hasSuffix("api_req_map/next")) {
            bean = BattleNext.deserialize(from: response)
        } else if (url.hasSuffix("api_req_battle_midnight/battle")) {
            bean = BattleNight.deserialize(from: response)
        } else if (url.hasSuffix("api_req_battle_midnight/sp_midnight")) {
            bean = BattleNightSp.deserialize(from: response)
        } else if (url.hasSuffix("api_req_sortie/battleresult")) {
            bean = BattleResult.deserialize(from: response)
        } else if (url.hasSuffix("api_req_map/start")) {
            bean = BattleStart.deserialize(from: response)
        } else if (url.hasSuffix("api_req_hensei/change")) {
            bean = Change.deserialize(from: response)
        } else if (url.hasSuffix("api_req_hokyu/charge")) {
            bean = Charge.deserialize(from: response)
        } else if (url.hasSuffix("api_req_kousyou/createitem")) {
            bean = CreateItem.deserialize(from: response)
        } else if (url.hasSuffix("api_req_kousyou/createship")) {
            bean = CreateShip.deserialize(from: response)
        } else if (url.hasSuffix("api_req_kousyou/createship_speedchange")) {
            bean = CreateShipSpeedChange.deserialize(from: response)
        } else if (url.hasSuffix("api_get_member/deck")) {
            bean = Deck.deserialize(from: response)
        } else if (url.hasSuffix("api_req_kousyou/destroyitem2")) {
            bean = DestroyItem.deserialize(from: response)
        } else if (url.hasSuffix("api_req_kousyou/destroyship")) {
            bean = DestroyShip.deserialize(from: response)
        } else if (url.hasSuffix("api_req_kousyou/getship")) {
            bean = GetShip.deserialize(from: response)
        } else if (url.hasSuffix("api_get_member/kdock")) {
            bean = KDock.deserialize(from: response)
        } else if (url.hasSuffix("api_get_member/material")) {
            bean = Material.deserialize(from: response)
        } else if (url.hasSuffix("api_req_mission/result")) {
            bean = MissionResult.deserialize(from: response)
        } else if (url.hasSuffix("api_get_member/ndock")) {
            bean = NDock.deserialize(from: response)
        } else if (url.hasSuffix("api_req_nyukyo/start")) {
            bean = NyukyoStart.deserialize(from: response)
        } else if (url.hasSuffix("api_port/port")) {
            bean = Port.deserialize(from: response)
        } else if (url.hasSuffix("api_req_kaisou/powerup")) {
            bean = PowerUp.deserialize(from: response)
        } else if (url.hasSuffix("api_req_practice/battle")) {
            bean = Practice.deserialize(from: response)
        } else if (url.hasSuffix("api_req_practice/midnight_battle")) {
            bean = PracticeNight.deserialize(from: response)
        } else if (url.hasSuffix("api_req_practice/battle_result")) {
            bean = PracticeResult.deserialize(from: response)
        } else if (url.hasSuffix("api_req_hensei/preset_select")) {
            bean = PresetSelect.deserialize(from: response)
        } else if (url.hasSuffix("api_req_quest/clearitemget")) {
            bean = QuestClear.deserialize(from: response)
        } else if (url.hasSuffix("api_get_member/questlist")) {
            bean = QuestList.deserialize(from: response)
        } else if (url.hasSuffix("api_req_kousyou/remodel_slot")) {
            bean = RemodelSlot.deserialize(from: response)
        } else if (url.hasSuffix("api_get_member/require_info")) {
            bean = RequireInfo.deserialize(from: response)
        } else if (url.hasSuffix("api_get_member/ship3")) {
            bean = Ship3.deserialize(from: response)
        } else if (url.hasSuffix("api_req_kaisou/slot_deprive")) {
            bean = SlotDeprive.deserialize(from: response)
        } else if (url.hasSuffix("api_req_kaisou/slot_exchange_index")) {
            bean = SlotExchangeIndex.deserialize(from: response)
        } else if (url.hasSuffix("api_get_member/slot_item")) {
            bean = SlotItem.deserialize(from: response)
        } else if (url.hasSuffix("api_req_nyukyo/speedchange")) {
            bean = SpeedChange.deserialize(from: response)
        } else if (url.hasSuffix("api_start2/getData")) {
            bean = Start.deserialize(from: response)
        }
        if let bean = bean {
            bean.setParams(form: request)
            bean.process()
        }
    }

    public func watch<T>(data: Observable<T>, watcher: @escaping (Event<T>) -> Void) {
        data.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .observeOn(MainScheduler.instance)
                .subscribe(watcher)
    }

}
