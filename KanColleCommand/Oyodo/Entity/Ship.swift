//
// Created by CC on 2019-02-10.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation

/** 小破(75%)  */
let SLIGHT_DAMAGE = 0.75
/** 中破(50%)  */
let HALF_DAMAGE = 0.5
/** 大破(25%)  */
let BADLY_DAMAGE = 0.25

// Air power mastery bonus
let kBasicMasteryMinBonus = Array(arrayLiteral: 0, 10, 25, 40, 55, 70, 85, 100)
let kBasicMasteryMaxBonus = Array(arrayLiteral: 9, 24, 39, 54, 69, 84, 99, 120)
let kFighterMasteryBonus = Array(arrayLiteral: 0, 0, 2, 5, 9, 14, 14, 22, 0, 0, 0)
let kSeaBomberMasteryBonus = Array(arrayLiteral: 0, 0, 1, 1, 1, 3, 3, 6, 0, 0, 0)

class Ship {

    var id: Int = 0
    var sortNum: Int = 0 //图鉴编号
    var level: Int = 0 //等级
    var nowHp: Int = 0 //当前HP
    var maxHp: Int = 0 //最大HP
    var nowFuel: Int = 0 //当前油料
    var maxFuel: Int = 0 //最大油料
    var nowBullet: Int = 0 //当前弹药
    var maxBullet: Int = 0 //最大弹药
    var condition: Int = 0 //士气
    var name: String = "" //舰名
    var items = Array<Int>() //装备
    var itemEx = 0 //打孔装备
    var soku: Int = 0 //航速
    var carrys = Array<Int>()//搭载
    var scout: Int = 0 //索敌
    var yomi: String = "" //舰假名或舰阶
    var type: Int = 0 //舰种

    var damage = Array<Int>() //损伤

    init(portShip: ApiShip, rawShip: ApiMstShip) {
        id = portShip.api_id
        sortNum = portShip.api_sortno
        level = portShip.api_lv
        nowHp = portShip.api_nowhp
        maxHp = portShip.api_maxhp
        nowFuel = portShip.api_fuel
        nowBullet = portShip.api_bull
        condition = portShip.api_cond
        let slotCount = portShip.api_slotnum
        if (slotCount > 0) {
            for num in 0...(slotCount - 1) {
                if let item = portShip.api_slot?[num] {
                    items.append(item)
                }
            }
        }
        itemEx = portShip.api_slot_ex
        soku = portShip.api_soku
        if let list = portShip.api_onslot {
            carrys += list
        }
        scout = portShip.api_sakuteki?[0] ?? 0
        maxFuel = rawShip.api_fuel_max ?? 0
        maxBullet = rawShip.api_bull_max ?? 0
        name = rawShip.api_name ?? ""
        type = rawShip.api_stype ?? 0
    }

    init(apiShip: ApiShipData, rawShip: ApiMstShip) {
        id = apiShip.api_id
        sortNum = apiShip.api_sortno
        level = apiShip.api_lv
        nowHp = apiShip.api_nowhp
        maxHp = apiShip.api_maxhp
        nowFuel = apiShip.api_fuel
        nowBullet = apiShip.api_bull
        condition = apiShip.api_cond
        //for num in 0...apiShip.api_slotnum {
        //    let item = apiShip.api_slot[num]
        //    items.append(item)
        //}
        itemEx = apiShip.api_slot_ex
        soku = apiShip.api_soku
        carrys += apiShip.api_onslot
        scout = apiShip.api_sakuteki[0]
        maxFuel = rawShip.api_fuel_max ?? 0
        maxBullet = rawShip.api_bull_max ?? 0
        name = rawShip.api_name ?? ""
        type = rawShip.api_stype ?? 0
    }

    init(rawShip: ApiMstShip) {
        id = rawShip.api_id ?? -1
        sortNum = rawShip.api_sortno ?? -1
        name = rawShip.api_name ?? ""
        soku = rawShip.api_soku ?? -1
        yomi = rawShip.api_yomi ?? ""
        type = rawShip.api_stype ?? -1
    }

}

extension Ship {

    func hp() -> Int {
        return max(0, nowHp - damage.reduce(0, +))
    }

    func getAirPower() -> Array<Int> {
        var totalAAC = Array<Int>(arrayLiteral: 0, 0)
        for (index, equipId) in items.enumerated() {
            let carry = carrys[safe: index] ?? 0
            if let slot = Fleet.instance.slotMap[equipId] {
                let baseAAC = calcBasicAAC(type: slot.typeCalc, aac: slot.calcLevelAAC(), carry: carry)
                let masteryAAC = slot.calcMasteryAAC(mode: 0)
                totalAAC[0] += Int(floor(baseAAC + masteryAAC[0]))
                totalAAC[1] += Int(floor(baseAAC + masteryAAC[1]))
            }
        }
        return totalAAC
    }

    private func calcBasicAAC(type: Int, aac: Double, carry: Int) -> Double {
        var result: Double
        if (type == FIGHTER
                || type == BOMBER
                || type == TORPEDO_BOMBER
                || type == SEA_BOMBER
                || type == SEA_FIGHTER
                || type == LBA_AIRCRAFT
                || type == ITCP_FIGHTER
                || type == JET_FIGHTER
                || type == JET_BOMBER
                || type == JET_TORPEDO_BOMBER) {
            result = sqrt(Double(carry)) * aac
        } else {
            result = 0
        }
        return result
    }

}
