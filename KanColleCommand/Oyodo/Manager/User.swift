//
// Created by CC on 2019-02-10.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import RxSwift

class User {

    static let instance = User()

    var nickname = BehaviorSubject<String>.init(value: "") //昵称
    var level = BehaviorSubject<Int>.init(value: 0) //等级
    var shipCount = BehaviorSubject<Int>.init(value: 0) //拥有舰娘
    var shipMax = BehaviorSubject<Int>.init(value: 0) //最大舰娘
    var slotCount = BehaviorSubject<Int>.init(value: 0) //拥有装备
    var slotMax = BehaviorSubject<Int>.init(value: 0) //最大装备
    var kDockCount = BehaviorSubject<Int>.init(value: 2) //开放建造池
    var nDockCount = BehaviorSubject<Int>.init(value: 2) //开放维修池
    var deckCount = BehaviorSubject<Int>.init(value: 4) //开放舰队

}