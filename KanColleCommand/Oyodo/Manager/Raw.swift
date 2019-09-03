//
// Created by CC on 2019-02-09.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation

class Raw {

    static let instance = Raw()

    var rawShipMap = Dictionary<Int, ApiMstShip>()
    var rawSlotMap = Dictionary<Int, ApiMstSlotitem>()

}