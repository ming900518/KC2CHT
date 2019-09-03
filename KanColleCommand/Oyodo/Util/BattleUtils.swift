//
// Created by CC on 2019-03-17.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation

func buildHeadingStr(heading: Int) -> String {
    var result = ""
    switch (heading) {
    case 1:
        result = "同航戰"
        break
    case 2:
        result = "反航戰"
        break
    case 3:
        result = "T有利"
        break
    case 4:
        result = "T不利"
        break
    default:
        result = "航向未知"
        break
    }
    return result
}

func buildAirCommandStr(air: Int) -> String {
    var result = ""
    switch (air) {
    case 0:
        result = "航空均衡"
        break
    case 1:
        result = "制空權確保"
        break
    case 2:
        result = "航空優勢"
        break
    case 3:
        result = "航空劣勢"
        break
    case 4:
        result = "制空權喪失"
        break
    default:
        result = "制空權未知"
        break
    }
    return result
}
