//
// Created by CC on 2019-02-10.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import RxSwift

class Resource {

    static let instance = Resource()

    var fuel = BehaviorSubject<Int>.init(value: 0) //油
    var ammo = BehaviorSubject<Int>.init(value: 0) //弹
    var metal = BehaviorSubject<Int>.init(value: 0) //钢
    var bauxite = BehaviorSubject<Int>.init(value: 0) //铝
    var bucket = BehaviorSubject<Int>.init(value: 0) //桶
    var burner = BehaviorSubject<Int>.init(value: 0) //喷火
    var research = BehaviorSubject<Int>.init(value: 0) //紫菜
    var improve = BehaviorSubject<Int>.init(value: 0) //螺丝

}