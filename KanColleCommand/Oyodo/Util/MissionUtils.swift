//
// Created by CC on 2019-03-31.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

enum MissionRequireType {
    case NONE,
         BATTLE, //出击
         EXPEDITION, //远征
         REPAIR, //入渠
         SUPPLY, //补给
         PRACTICE, //演习
         CREATE_ITEM, //开发
         CREATE_SHIP, //建造
         DESTROY_ITEM, //废弃
         DESTROY_SHIP, //解体
         REMODEL_SLOT, //改修
         POWER_UP //强化
}

class MissionData {

    public let description: String
    public let require: Int
    public let type: MissionRequireType
    public let processor: (AnyObject) -> Int

    init(description: String, require: Int, type: MissionRequireType,
         processor: @escaping (AnyObject) -> Int) {
        self.description = description
        self.require = require
        self.type = type
        self.processor = processor
    }

}

func getMissionData(byId: Int) -> MissionData? {
    //var data: MissionData? = nil
    let data: MissionData? = nil
    switch (byId) {

    default:
        break
    }
    return data
}

func setMissionProgress(bean: JsonBean, type: MissionRequireType) {
    do {
        let questMap = try Mission.instance.questMap.value()
        questMap.values
                .filter { quest in
                    quest.type == type
                }
                .forEach { quest in
                    setQuestCounter(quest: quest, bean: bean)
                }
        Mission.instance.questMap.onNext(questMap)
    } catch {
        print("Got error in setMissionProgress")
    }
}

func setQuestCounter(quest: Quest, bean: JsonBean) {
    let increment = getMissionData(byId: quest.id)?.processor(bean) ?? 0
    quest.current = min(quest.max, quest.current + increment)
}

func getQuestIndicatorColor(type: Int) -> UIColor {
    var result = UIColor(hexString: "#A1A1A1")
    switch (type) {
    case 1:
        result = UIColor(hexString: "#2C8D50")
        break
    case 2:
        result = UIColor(hexString: "#E14A4A")
        break
    case 3:
        result = UIColor(hexString: "#9DCD66")
        break
    case 4:
        result = UIColor(hexString: "#42BCB6")
        break
    case 5:
        result = UIColor(hexString: "#E6CB6F")
        break
    case 6:
        result = UIColor(hexString: "#825940")
        break
    case 7:
        result = UIColor(hexString: "#CFA9E0")
        break
    default:
        break
    }
    return result
}

func isBattleWin(bean: IBattleResult?) -> Bool {
    let rank = bean?.api_data?.api_win_rank ?? ""
    return (rank == "S" || rank == "A" || rank == "B")
}

func isShipSink(ship: Ship) -> Bool {
    return (ship.hp() <= 0)
}

func isPracticeWin(bean: PracticeResult?) -> Bool {
    let rank = bean?.api_data?.api_win_rank ?? ""
    return (rank == "S" || rank == "A" || rank == "B")
}

func isExpeditionSuccess(bean: MissionResult?) -> Bool {
    return (bean?.api_data?.api_clear_result == 1)
}

func isPowerUpSuccess(bean: PowerUp?) -> Bool {
    return (bean?.api_data?.api_powerup_flag == 1)
}
