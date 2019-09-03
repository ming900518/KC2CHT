//
// Created by CC on 2019-02-10.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation

class Slot {

    var name: String = ""
    var type: Int = 0 //分类
    var typeCalc: Int = 0 //计算分类
    var aac: Int = 0 //对空
    var mastery: Int = 0 //熟练度
    var level: Int = 0 //改修
    var scout: Int = 0 //索敌

    init(raw: ApiMstSlotitem?, port: ApiSlotItem?) {
        name = raw?.api_name ?? ""
        type = raw?.api_type?[3] ?? 0
        typeCalc = raw?.api_type?[2] ?? 0
        aac = raw?.api_tyku ?? 0
        scout = raw?.api_saku ?? 0
        mastery = port?.api_alv ?? 0
        level = port?.api_level ?? 0
    }

    init(raw: ApiMstSlotitem?) {
        name = raw?.api_name ?? ""
        type = raw?.api_type?[3] ?? 0
        typeCalc = raw?.api_type?[2] ?? 0
        aac = raw?.api_tyku ?? 0
        scout = raw?.api_saku ?? 0
    }

    func calcLevelAAC() -> Double {
        var result: Double
        switch (typeCalc) {
        case FIGHTER:
            result = Double(aac) + 0.2 * Double(level)
            break
        case BOMBER, JET_BOMBER:
            if (aac > 0) {
                result = Double(aac) + 0.25 * Double(level)
            } else {
                result = 0
            }
            break
        default:
            result = Double(aac)
            break
        }
        return result
    }

    func calcMasteryAAC(mode: Int) -> Array<Double> {
        var minMastery = mastery
        if (mode == 1) {
            minMastery = 0
        }
        var rangeAAC = Array<Double>(arrayLiteral: 0, 0)
        switch (typeCalc) {
        case FIGHTER, SEA_FIGHTER:
            rangeAAC[0] += Double(kFighterMasteryBonus[minMastery])
            rangeAAC[1] += Double(kFighterMasteryBonus[mastery])
            rangeAAC[0] += sqrt(Double(kBasicMasteryMinBonus[minMastery]) / 10)
            rangeAAC[1] += sqrt(Double(kBasicMasteryMaxBonus[mastery]) / 10)
            break
        case BOMBER, TORPEDO_BOMBER, JET_BOMBER:
            rangeAAC[0] += sqrt(Double(kBasicMasteryMinBonus[minMastery]) / 10)
            rangeAAC[1] += sqrt(Double(kBasicMasteryMaxBonus[mastery]) / 10)
            break
        case SEA_BOMBER:
            rangeAAC[0] += Double(kSeaBomberMasteryBonus[minMastery])
            rangeAAC[1] += Double(kSeaBomberMasteryBonus[mastery])
            rangeAAC[0] += sqrt(Double(kBasicMasteryMinBonus[minMastery]) / 10)
            rangeAAC[1] += sqrt(Double(kBasicMasteryMaxBonus[mastery]) / 10)
            break
        default:
            break
        }
        return rangeAAC
    }

    func calcScout() -> Double {
        var result: Double
        switch (typeCalc) {
        case TORPEDO_BOMBER:
            result = 0.8 * Double(scout)
            break
        case SCOUT, SCOUT_II:
            result = 1.0 * Double(scout)
            break
        case SEA_SCOUT:
            result = 1.2 * (Double(scout) + 1.2 * sqrt(Double(level)))
            break
        case SEA_BOMBER:
            result = 1.1 * Double(scout)
            break
        case RADAR_LARGE:
            result = 0.6 * (Double(scout) + 1.4 * sqrt(Double(level)))
            break
        case RADAR_SMALL:
            result = 0.6 * (Double(scout) + 1.25 * sqrt(Double(level)))
            break
        default:
            result = 0.6 * Double(scout)
            break
        }
        return result
    }

}
