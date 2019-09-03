//
// Created by CC on 2019-02-12.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import RxSwift

class Dock {

    static let instance = Dock()

    var expeditionList: Array<BehaviorSubject<Expedition>>
    var buildList: Array<BehaviorSubject<Build>>
    var repairList: Array<BehaviorSubject<Repair>>

    private init() {
        var expeditions = Array<BehaviorSubject<Expedition>>()
        var builds = Array<BehaviorSubject<Build>>()
        var repairs = Array<BehaviorSubject<Repair>>()
        for _ in 1...MAX_FLEET_COUNT {
            expeditions.append(BehaviorSubject.init(value: Expedition()))
            builds.append(BehaviorSubject.init(value: Build()))
            repairs.append(BehaviorSubject.init(value: Repair()))
        }
        expeditionList = expeditions
        buildList = builds
        repairList = repairs
    }

}