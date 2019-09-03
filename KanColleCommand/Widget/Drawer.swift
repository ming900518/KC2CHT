//
// Created by CC on 2019-02-05.
// Copyright (c) 2019 CC. All rights reserved.
//

import UIKit
import Foundation
import SnapKit

class Drawer: UIView {

    private let kWidth = 400
    private var currPosition: Int = 0
    private var expanded = false

    private var positionConstraint: Constraint? = nil
    private var previousAnimator: UIViewPropertyAnimator? = nil

    private var container: ViewController!
    private var fleetVC: FleetVC!
    private var battleVC: BattleVC!
    private var missionVC: MissionVC!

    private var maskingView: UIView!
    private var gripView: GripView!

    init() {
        super.init(frame: CGRect.zero)
        setup()
    }

    private init(embeddedView: UIView?) {
        super.init(frame: CGRect.zero)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
    }

    public func attachTo(controller: ViewController) {
        container = controller
        let view = container.view!
        view.addSubview(self)
        self.snp.makeConstraints { maker in
            maker.height.equalToSuperview()
            maker.width.equalTo(kWidth)
            self.positionConstraint = maker.left.equalTo(view.snp.right).constraint
        }

        gripView = GripView()
        view.addSubview(gripView)
        gripView.gripTo(view: self)
        gripView.setDelegate(delegate: self)

        maskingView = UIView()
        maskingView.backgroundColor = UIColor.init(white: 0, alpha: 0.6)
        maskingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap)))
        maskingView.isHidden = true
        view.addSubview(maskingView)
        maskingView.snp.makeConstraints { maker in
            maker.left.equalTo(view)
            maker.top.equalTo(view)
            maker.bottom.equalTo(view)
            maker.right.equalTo(gripView.snp.left)
        }

        fleetVC = FleetVC()
        battleVC = BattleVC()
        missionVC = MissionVC()
        #if swift(>=4.2)
        container.addChild(fleetVC)
        container.addChild(battleVC)
        container.addChild(missionVC)
        #else
        container.addChildViewController(fleetVC)
        container.addChildViewController(battleVC)
        container.addChildViewController(missionVC)
        #endif
        fleetVC.view.frame = self.bounds
        battleVC.view.frame = self.bounds
        missionVC.view.frame = self.bounds
        self.addSubview(fleetVC.view)
        self.addSubview(battleVC.view)
        self.addSubview(missionVC.view)
    }

    @objc private func onTap() {
        if (expanded) {
            UIView.animate(withDuration: 0.5,
                    animations: { () -> Void in self.maskingView.alpha = 0 },
                    completion: { b in self.maskingView.isHidden = true }
            )
            UIView.animate(withDuration: 0.5) { () -> Void in
                self.positionConstraint?.update(offset: 0)
                self.superview?.layoutIfNeeded()
            }
            expanded = false
        }
        gripView.selectItem(-1)
    }

}

extension Drawer: GripDelegate {

    func onCheck(index: Int) {
        switch (index) {
        case 1:
            bringSubview(toFront: battleVC.view)
            break
        case 2:
            bringSubview(toFront: missionVC.view)
            break
        default:
            bringSubview(toFront: fleetVC.view)
            break
        }
        if (!expanded) {
            self.maskingView.isHidden = false
            UIView.animate(withDuration: 0.5,
                    animations: { () -> Void in self.maskingView.alpha = 1 }
            )
            UIView.animate(withDuration: 0.5) { () -> Void in
                self.positionConstraint?.update(offset: -self.kWidth)
                self.superview?.layoutIfNeeded()
            }
            expanded = true
        }
    }

}
