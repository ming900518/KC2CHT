//
// Created by CC on 2019-02-13.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import RxSwift

class Battle {

    static let instance = Battle()

    var phase: BehaviorSubject<Phase> = BehaviorSubject.init(value: .Idle)
    var area: Int = -1
    var map: Int = -1
    var heading: Int = -1
    var airCommand: Int = -1
    var rank: String = ""
    var route: Int = -1
    var nodeType: Int = -1
    var get: String = ""

    var friendIndex = -1
    //    var friendList: MutableList<BehaviorSubject<Ship>> = mutableListOf()
    var friendFormation: Int = -1
    var enemyList: Array<Ship> = Array()
    var subEnemyList: Array<Ship> = Array()
    var enemyFormation: Int = -1
    var friendCombined = false
    var enemyCombined = false

    func calcTargetDamage(targetList: Array<Any>?, damageList: Array<Any>?, flagList: Array<Int>?, enemyOnly: Bool = false) {
        guard let targets = targetList, let damages = damageList, let flags = flagList else {
            return
        }
        var shipIds = Array<Int>()
        for (i, target) in targets.enumerated() {
            let flag = flags[i]
            let tArr = target as! Array<Int>
            let dArr = damages[i] as! Array<Double>
            for (j, t) in tArr.enumerated() {
                if (t < 0) {
                    continue
                }
                if (enemyOnly && flag == 1) {
                    continue
                }
                var index = t
                let subTeam = (t >= 6)
                if (subTeam) {
                    index = t - 6
                }
                switch flag {
                case 0:
                    var ship: Ship?
                    if (subTeam) {
                        ship = subEnemyList[safe: index]
                    } else {
                        ship = enemyList[safe: index]
                    }
                    if let count = ship?.damage.count {
                        if (count > 0) {
                            ship?.damage[count - 1] += Int(dArr[safe: j] ?? 0)
                        }
                    }
                    break
                case 1:
                    var team = friendIndex
                    if (subTeam) {
                        team = 1
                    }
                    if let ship = Fleet.instance.getShips(index: team)[safe: index] {
                        let count = ship.damage.count
                        if (count > 0) {
                            ship.damage[count - 1] += Int(dArr[safe: j] ?? 0)
                        }
                        shipIds.append(ship.id)
                    }
                    break
                default:
                    print("Unexpected flag \(flag)")
                    break
                }
            }
        }
        Fleet.instance.shipWatcher.onNext(Transform.Change(shipIds))
    }

    func calcFriendOrdinalDamage(damageList: Array<Double>?, combined: Bool = false) {
        guard let damages = damageList else {
            return
        }
        var shipIds = Array<Int>()
        var values = damages
        if (damages.count == 7) {
            values = Array(damages.prefix(6))
        }
        for (i, value) in values.enumerated() {
            var fleet: Int
            if (friendCombined) {
                if (combined || i >= 6) {
                    fleet = 1
                } else {
                    fleet = 0
                }
            } else {
                fleet = friendIndex
            }
            var index: Int
            if (i >= 6) {
                index = i - 6
            } else {
                index = i
            }
            let friendList = Fleet.instance.getShips(index: fleet)
            if let ship = friendList[safe: index] {
                let damage = Int(value)
                if (damage > 0) {
                    let count = ship.damage.count
                    if (count > 0) {
                        ship.damage[count - 1] += damage
                    }
                }
                shipIds.append(ship.id)
            }
        }
        Fleet.instance.shipWatcher.onNext(Transform.Change(shipIds))
    }

    func calcEnemyOrdinalDamage(damageList: Array<Double>?, combined: Bool = false) {
        guard let damages = damageList else {
            return
        }
        var values = damages
        if (damages.count == 7) {
            values = Array(damages.prefix(6))
        }
        for (i, value) in values.enumerated() {
            var index: Int
            if (i >= 6) {
                index = i - 6
            } else {
                index = i
            }
            let ship: Ship?
            if (combined || i >= 6) {
                ship = subEnemyList[safe: index]
            } else {
                ship = enemyList[safe: index]
            }
            if let ship = ship, (value > 0) {
                let count = ship.damage.count
                if (count > 0) {
                    ship.damage[count - 1] += Int(value)
                }
            }
        }
    }

    func newTurn() {
        if (friendCombined) {
            Fleet.instance.getShips(index: 0).forEach { ship in
                addDamage(to: ship)
            }
            Fleet.instance.getShips(index: 1).forEach { ship in
                addDamage(to: ship)
            }
        } else {
            Fleet.instance.getShips(index: friendIndex).forEach { ship in
                addDamage(to: ship)
            }
        }
        enemyList.forEach { ship in
            addDamage(to: ship)
        }
        if (enemyCombined) {
            subEnemyList.forEach { ship in
                addDamage(to: ship)
            }
        }
    }

    func finishBattle() {
        if (friendCombined) {
            Fleet.instance.getShips(index: 0).forEach { ship in
                settleDamage(to: ship)
            }
            Fleet.instance.getShips(index: 1).forEach { ship in
                settleDamage(to: ship)
            }
        } else {
            Fleet.instance.getShips(index: friendIndex).forEach { ship in
                settleDamage(to: ship)
            }
        }
        enemyList.forEach { ship in
            settleDamage(to: ship)
        }
        if (enemyCombined) {
            subEnemyList.forEach { ship in
                settleDamage(to: ship)
            }
        }
    }

    func calcRank() {
        var friends = Array<Ship>()
        if (friendCombined) {
            friends.append(contentsOf: Fleet.instance.getShips(index: 0))
            friends.append(contentsOf: Fleet.instance.getShips(index: 1))
        } else {
            friends.append(contentsOf: Fleet.instance.getShips(index: friendIndex))
        }
        let friendCount = friends.count
        let friendSunkCount = friends.filter { (ship: Ship) -> Bool in
            ship.hp() <= 0
        }.count
        let friendNowSum = friends.reduce(0) { (result: Int, ship: Ship) -> Int in
            return result + ship.nowHp
        }
        let friendDamageSum = friends.reduce(0) { (result: Int, ship: Ship) -> Int in
            return result + ship.damage.reduce(0, +)
        }
        var enemies = enemyList
        if (enemyCombined) {
            enemies.append(contentsOf: subEnemyList)
        }
        let enemyCount = enemies.count
        let enemySunkCount = enemies.filter { (ship: Ship) -> Bool in
            ship.hp() <= 0
        }.count
        let enemyNowSum = enemies.reduce(0) { (result: Int, ship: Ship) -> Int in
            return result + ship.nowHp
        }
        let enemyFlagShipSunk = (enemies[safe: 0]?.hp() ?? 0) <= 0
        let enemyDamageSum = enemies.reduce(0) { (result: Int, ship: Ship) -> Int in
            return result + ship.damage.reduce(0, +)
        }

        let friendDamageRate = Float(friendDamageSum) * 100 / Float(friendNowSum)
        let enemyDamageRate = Float(enemyDamageSum) * 100 / Float(enemyNowSum)

        if (friendSunkCount == 0) {
            if (enemySunkCount == enemyCount) {
                if (friendDamageSum == 0) {
                    rank = "SS"
                } else {
                    rank = "S"
                }
            } else if (enemyCount > 1 && enemySunkCount >= Int(floor(0.7 * Float(enemyCount)))) {
                rank = "A"
            } else if (enemyFlagShipSunk && friendSunkCount < enemySunkCount) {
                rank = "B"
            } /*else if (friendCount == 1 && friendFlagshipCritical) {
                rank = "D敗"
            }*/ else if (enemyDamageRate * 2 > friendDamageRate * 5) {
                rank = "B"
            } else if (enemyDamageRate * 10 > friendDamageRate * 9) {
                rank = "C"
            } else {
                rank = "D"
            }
        } else if (friendCount - friendSunkCount == 1) {
            rank = "E"
        } else {
            rank = "D"
        }
    }

    func calcAirRank() {
        var friends = Array<Ship>()
        if (friendCombined) {
            friends.append(contentsOf: Fleet.instance.getShips(index: 0))
            friends.append(contentsOf: Fleet.instance.getShips(index: 1))
        } else {
            friends.append(contentsOf: Fleet.instance.getShips(index: friendIndex))
        }
        let friendNowSum = friends.reduce(0) { (result: Int, ship: Ship) -> Int in
            return result + ship.nowHp
        }
        let friendDamageSum = friends.reduce(0) { (result: Int, ship: Ship) -> Int in
            return result + ship.damage.reduce(0, +)
        }
        let friendDamageRate = Float(friendDamageSum) * 100 / Float(friendNowSum)
        if (friendDamageSum <= 0) {
            rank = "SS"
        } else if (friendDamageRate < 10) {
            rank = "A"
        } else if (friendDamageRate < 20) {
            rank = "B"
        } else if (friendDamageRate < 50) {
            rank = "C"
        } else if (friendDamageRate < 80) {
            rank = "D"
        } else {
            rank = "E"
        }
    }

    func phaseShift(value: Phase) {
        phase.onNext(value)
    }

    func clear() {
        friendIndex = -1
        friendFormation = -1
        friendCombined = false
        enemyList.removeAll()
        subEnemyList.removeAll()
        enemyFormation = -1
        enemyCombined = false
        area = -1
        map = -1
        heading = -1
        airCommand = -1
        rank = ""
        route = -1
        nodeType = -1
        get = ""
    }

    private func addDamage(to ship: Ship) {
        ship.damage.append(0)
    }

    private func settleDamage(to ship: Ship) {
        ship.nowHp -= ship.damage.reduce(0, +)
        ship.damage.removeAll()
    }

}

enum Phase {
    case Idle
    case Start
    case BattleDaytime
    case BattleNight
    case BattleNightSp
    case BattleAir
    case BattleResult
    case Practice
    case PracticeNight
    case PracticeResult
    case BattleCombined
    case BattleCombinedAir
    case BattleCombinedEach
    case BattleCombinedEc
    case BattleCombinedWater
    case BattleCombinedWaterEach
    case BattleCombinedNight
    case BattleCombinedResult
    case Next
}

