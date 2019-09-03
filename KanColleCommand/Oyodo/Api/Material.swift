//
// Created by CC on 2019-03-28.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import HandyJSON
import RxSwift

class Material: JsonBean {

    var api_result: Int = 0
    var api_result_msg: String = ""
    var api_data = Array<MaterialApiData>()

    override func process() {
        if let fuel = api_data[safe: 0]?.api_value {
            Resource.instance.fuel.onNext(fuel)
        }
        if let ammo = api_data[safe: 1]?.api_value {
            Resource.instance.ammo.onNext(ammo)
        }
        if let metal = api_data[safe: 2]?.api_value {
            Resource.instance.metal.onNext(metal)
        }
        if let bauxite = api_data[safe: 3]?.api_value {
            Resource.instance.bauxite.onNext(bauxite)
        }
        if let burner = api_data[safe: 4]?.api_value {
            Resource.instance.bauxite.onNext(burner)
        }
        if let bucket = api_data[safe: 5]?.api_value {
            Resource.instance.bauxite.onNext(bucket)
        }
        if let research = api_data[safe: 6]?.api_value {
            Resource.instance.bauxite.onNext(research)
        }
        if let improve = api_data[safe: 7]?.api_value {
            Resource.instance.bauxite.onNext(improve)
        }
    }

}

class MaterialApiData: HandyJSON {

    var api_member_id: Int = 0
    var api_id: Int = 0
    var api_value: Int = 0

    required init() {

    }
}
