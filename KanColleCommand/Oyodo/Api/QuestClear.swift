//
// Created by CC on 2019-03-24.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import HandyJSON
import RxSwift

class QuestClear: JsonBean {

    var api_result: Int = 0
    var api_result_msg: String = ""
    var api_data: QuestClearApiData? = QuestClearApiData()

    override func process() {
        let questId = parse(value: params["api_quest_id"])
        do {
            var observable = try Mission.instance.questMap.value()
            observable.removeValue(forKey: questId)
            Mission.instance.questMap.onNext(observable)
        } catch {
            print("Got error in QuestClear process")
        }
    }

}

class QuestClearApiData: HandyJSON {

    var api_material = Array<Int>()
    var api_bounus_count: Int = 0
    var api_bounus = Array<Int>()

    required init() {

    }

}

class ApiBounu: HandyJSON {

    var api_type: Int = 0
    var api_count: Int = 0
    var api_item: ApiItem? = ApiItem()

    required init() {

    }

}

class ApiItem: HandyJSON {

    var api_id: Int = 0
    var api_name: String = ""

    required init() {

    }

}
