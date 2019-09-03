//
// Created by CC on 2019-03-19.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import HandyJSON

class MapSpotHelper {

    static let instance = MapSpotHelper()

    private var mapSpot: MapSpot?

    init() {
        do {
            if let mapFilePath = Bundle.main.path(forResource: "map", ofType: "json") {
                let data = try Data(contentsOf: URL(fileURLWithPath: mapFilePath))
                if let content = String(data: data, encoding: .utf8) {
                    mapSpot = self.parse(data: content)
                }
            }
        } catch {
            print("Error init MapSpotHelper")
        }
    }

    private func parse(data: String) -> MapSpot? {
        return MapSpot.deserialize(from: data)
    }

    func getSpotMarker(area: Int, map: Int, route: Int) -> Array<String>? {
        let mapData = mapSpot?.data?["\(area)-\(map)"]
        let spot = mapData?.route?["\(route)"]
        print(spot ?? "nnnnnnn")
        return spot
    }

}