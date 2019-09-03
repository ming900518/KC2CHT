//
// Created by CC on 2019-02-12.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import RxSwift
import HandyJSON

class KDock: JsonBean {

    var api_result: Int = 0
    var api_result_msg: String = ""
    var api_data: Array<KDockApiData>?

    override func process() {
        if let list = api_data {
            for (index, item) in list.enumerated() {
                Dock.instance.buildList[index].onNext(Build(entity: item))
            }
        }
    }

}

class KDockApiData: HandyJSON {

    var api_id: Int = 0
    var api_state: Int = 0
    var api_created_ship_id: Int = 0
    var api_complete_time: Int64 = 0
    var api_complete_time_str: String = ""
    var api_item1: Int = 0
    var api_item2: Int = 0
    var api_item3: Int = 0
    var api_item4: Int = 0
    var api_item5: Int = 0

    required init() {

    }

}
