//
// Created by CC on 2019-02-12.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import RxSwift

class Deck: JsonBean {

    var api_result: Int = 0
    var api_result_msg: String = ""
    var api_data: Array<DeckApiData>?

    required init() {

    }

    override func process() {
        var shipIds = Array<Int>()
        if let list = api_data {
            for (index, item) in list.enumerated() {
                let expedition = Expedition(entity: item)
                if (expedition.valid()) {
                    Dock.instance.expeditionList[index].onNext(expedition)
                    do {
                        shipIds += try Fleet.instance.deckShipIds[index].value()
                    } catch {
                        // do nothing
                    }
                }
            }
        }
        Fleet.instance.shipWatcher.onNext(Transform.Change(shipIds))
    }

}

class DeckApiData {
    var api_member_id: Int = 0
    var api_id: Int = 0
    var api_name: String = ""
    var api_name_id: String = ""
    var api_mission: Array<String>?
    var api_flagship: String = ""
    var api_ship: Array<Int>?
}