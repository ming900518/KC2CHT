//
// Created by CC on 2019-02-10.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import RxSwift

let MAX_FLEET_COUNT = 4
let MAX_SHIP_COUNT = Array(arrayLiteral: 6, 6, 6, 6)

//let MAX_SHIP_COUNT = Array(arrayLiteral: 6, 6, 7, 6)

class Fleet {

    static let instance = Fleet()

    var deckShipIds: Array<BehaviorSubject<Array<Int>>>
    var deckNames: Array<BehaviorSubject<String>>
    var shipMap = Dictionary<Int, Ship>()
    var slotMap = Dictionary<Int, Slot>()
    var shipWatcher = PublishSubject<Transform>.init()
    var slotWatcher = PublishSubject<Transform>.init()
    var lastUpdate: Int64 = 0

    private init() {
        var ids = Array<BehaviorSubject<Array<Int>>>()
        var names = Array<BehaviorSubject<String>>()
        for i in 1...MAX_FLEET_COUNT {
            ids.append(BehaviorSubject.init(value: Array<Int>()))
            names.append(BehaviorSubject.init(value: String(format: "%d", arguments: [i])))
        }
        deckShipIds = ids
        deckNames = names
    }

}

enum Transform {
    case All
    case Add(Array<Int>)
    case Remove(Array<Int>)
    case Change(Array<Int>)
}

enum Speed {
    case SLOW
    case FAST
}

extension Fleet {

    func getShips(index: Int) -> Array<Ship> {
        do {
            return try deckShipIds[index].value().filter { (i: Int) -> Bool in
                i > 0
            }.map { i -> Ship in
                try shipMap[i]!
            }
        } catch {
            return Array()
        }
    }

    func isLock(index: Int) -> Bool {
        var result = false
        do {
            try result = (index >= User.instance.deckCount.value())
        } catch {
            print("Error when call isLock(\(index)")
        }
        return result
    }

    func isInBattle(index: Int) -> Bool {
        var result = false
        if (Battle.instance.friendIndex >= 0) {
            if (Battle.instance.friendCombined) {
                result = (index == 0 || index == 1)
            } else {
                result = (Battle.instance.friendIndex == index)
            }
        }
        return result
    }

    func isInExpedition(index: Int) -> Bool {
        let expedition = Dock.instance.expeditionList.first { it in
            var find = false
            do {
                try find = (it.value().fleetIndex == index + 1)
            } catch {
                print("Error when call isInExpedition(\(index)")
            }
            return find
        }
        var result = false
        if let expedition = expedition {
            do {
                try result = (Int(expedition.value().missionId) ?? 0 > 0)
            } catch {
                print("Error when call isInExpedition(\(index)")
            }
        }
        return result
    }

    func isBadlyDamage(index: Int) -> Bool {
        return getShips(index: index).filter { (ship: Ship) -> Bool in
            let curr = ship.hp()
            let total = ship.maxHp
            let percent = Double(curr) / Double(total)
            return percent >= 0.0 && percent < BADLY_DAMAGE
        }.count > 0
    }

    func isNeedSupply(index: Int) -> Bool {
        return getShips(index: index).filter { (ship: Ship) -> Bool in
            return (ship.nowFuel < ship.maxFuel) || (ship.nowBullet < ship.maxBullet)
        }.count > 0
    }

    func isMemberRepairing(index: Int) -> Bool {
        return getShips(index: index).filter { (ship: Ship) -> Bool in
            Dock.instance.repairList.contains { subject in
                do {
                    return try ship.id == subject.value().shipId
                } catch {
                    return false
                }
            }
        }.count > 0
    }

    func getFleetLevel(index: Int) -> Int {
        return getShips(index: index).reduce(0) { (result: Int, ship: Ship) -> Int in
            result + ship.level
        }
    }

    func getFleetSpeedType(index: Int) -> Speed {
        let isSlow = getShips(index: index).filter { (ship: Ship) -> Bool in
            ship.soku < 10
        }.count > 0
        if (isSlow) {
            return Speed.SLOW
        } else {
            return Speed.FAST
        }
    }

    func getFleetAirPower(index: Int) -> Array<Int> {
        var min = 0
        var max = 0
        getShips(index: index).forEach { ship in
            var airPower = ship.getAirPower()
            min += airPower[0]
            max += airPower[1]
        }
        return Array(arrayLiteral: min, max)
    }

    func getFleetScout(index: Int) -> Double {
        var equipScoutSum: Double = 0
        var shipScoutSum: Double = 0
        getShips(index: index).forEach { ship in
            var shipScout = Double(ship.scout)
            ship.items.map { id -> Slot? in
                Fleet.instance.slotMap[id]
            }.forEach { slot in
                if let slot = slot {
                    shipScout -= Double(slot.scout)
                    equipScoutSum += slot.calcScout()
                }
            }
            shipScoutSum += sqrt(shipScout)
        }
        return equipScoutSum + shipScoutSum + getCommandLevelPenaltyScout() + getFleetCountBonusScout(index: index)
    }

    private func getCommandLevelPenaltyScout() -> Double {
        var result: Double
        do {
            result = try ceil(Double(User.instance.level.value()) * 0.4) * -1
        } catch {
            result = 0
        }
        return result
    }

    private func getFleetCountBonusScout(index: Int) -> Double {
        var result: Double
        do {
            let shipCount = try deckShipIds[safe: index]?.value().filter { (i: Int) -> Bool in
                i > 0
            }.count ?? 0
            result = Double((MAX_SHIP_COUNT[index] - shipCount) * 2)
        } catch {
            result = 0
        }
        return result
    }

}
