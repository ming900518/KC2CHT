//
// Created by CC on 2019-03-19.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import HandyJSON

class MapSpot: HandyJSON {

    var meta: Any? = nil
    var data: Dictionary<String, MapData>? = nil

    required init() {

    }

}

class MapData: HandyJSON {

    var route: Dictionary<String, Array<String>>? = nil
    var spots: Dictionary<String, Array<Any>>? = nil

    required init() {

    }

}
