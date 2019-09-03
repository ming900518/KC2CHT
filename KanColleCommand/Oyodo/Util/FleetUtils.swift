//
// Created by CC on 2019-02-25.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import UIKit

func getFleetIndicatorColor(fleet: Int) -> UIColor {
    var result = UIColor.clear
    if (Fleet.instance.isLock(index: fleet)) {
        result = UIColor.init(white: 0.3, alpha: 1)
    } else if (Fleet.instance.isInBattle(index: fleet)) {
        result = UIColor.init(white: 0.3, alpha: 1)
    } else if (Fleet.instance.isInExpedition(index: fleet)) {
        result = UIColor.init(red: 0.0667, green: 0.514, blue: 0.776, alpha: 1)
    } else if (Fleet.instance.isBadlyDamage(index: fleet)) {
        result = UIColor.init(red: 0.714, green: 0.0745, blue: 0.0745, alpha: 1)
    } else if (Fleet.instance.isNeedSupply(index: fleet)) {
        result = UIColor.init(red: 0.749, green: 0.353, blue: 0.0706, alpha: 1)
    } else if (Fleet.instance.isMemberRepairing(index: fleet)) {
        result = UIColor.init(red: 0.749, green: 0.353, blue: 0.0706, alpha: 1)
    } else {
        result = UIColor.init(red: 0.0902, green: 0.706, blue: 0.345, alpha: 1)
    }
    return result
}

func getShipHpColor(percent: CGFloat) -> UIColor {
    var result = UIColor.init(red: 0.475, green: 0.475, blue: 0.475, alpha: 1)
    let value = Double(percent)
    if (value <= BADLY_DAMAGE) {
        result = UIColor.init(red: 0.502, green: 0.11, blue: 0.11, alpha: 1)
    } else if (value > BADLY_DAMAGE && value <= HALF_DAMAGE) {
        result = UIColor.init(red: 0.482, green: 0.271, blue: 0.098, alpha: 1)
    } else if (value > HALF_DAMAGE && value <= SLIGHT_DAMAGE) {
        result = UIColor.init(red: 0.463, green: 0.435, blue: 0.0706, alpha: 1)
    } else {
        result = UIColor.init(red: 0.114, green: 0.325, blue: 0.0902, alpha: 1)
    }
    return result
}

public func getSelectedIndicator(index: Int, size: CGSize) -> UIImage? {
    let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    context?.setFillColor(getFleetIndicatorColor(fleet: index).cgColor)
    context?.fill(rect)
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result
}

public func getUnselectedIndicator(index: Int, size: CGSize) -> UIImage? {
    let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    context?.setStrokeColor(getFleetIndicatorColor(fleet: index).cgColor)
    let path = UIBezierPath(roundedRect: rect, cornerRadius: 0)
    path.lineWidth = 2
    path.stroke()
    context?.addPath(path.cgPath)
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result
}

public func getTagImage(shipId: Int) -> UIImage? {
    if (shipId > 0) {
        for repair in Dock.instance.repairList {
            do {
                let id = try repair.value().shipId
                if (shipId == id) {
                    return UIImage(named: "tag_repair")
                }
            } catch {
                print("Got error in getTagImage")
            }
        }
    }
    return nil
}

func getConditionColor(cond: Int) -> UIColor {
    var result = UIColor.lightGray
    if (cond < 20) {
        result = UIColor.init(red: 0.776, green: 0.212, blue: 0.204, alpha: 1)
    } else if (cond >= 20 && cond < 30) {
        result = UIColor.init(red: 0.776, green: 0.463, blue: 0.204, alpha: 1)
    } else if (cond >= 50) {
        result = UIColor.init(red: 0.776, green: 0.737, blue: 0.204, alpha: 1)
    }
    return result
}
