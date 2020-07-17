//
// Created by CC on 2019-02-07.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

protocol GripDelegate {
    func onCheck(index: Int)
}

class GripView: UIView {

    private var delegate: GripDelegate? = nil
    private let titles = Array(arrayLiteral:"艦\n隊", "戰\n鬥", "任\n務")

    public func gripTo(view: UIView) {
        //backgroundColor = UIColor(white: 0.144, alpha: 1)
        if Setting.getUseTheme() == 1 {
            backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        } else {
            backgroundColor = UIColor(white: 0.185, alpha: 1)
        }
        self.snp.makeConstraints { maker in
            maker.height.equalTo(view.snp.height)
            maker.right.equalTo(view.snp.left)
            maker.width.equalTo(40)
        }
        let count = titles.count
        var last: UIButton? = nil
        for (i, title) in titles.enumerated() {
            if Setting.getOyodo() == 0 {
                let button = UIButton(type: .custom)
                button.tag = i
                button.setTitle(title, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                button.titleLabel?.lineBreakMode = .byWordWrapping
                button.titleLabel?.numberOfLines = 0
                button.addTarget(self, action: #selector(onClick), for: .touchUpInside)
                addSubview(button)
                var top: ConstraintItem = view.snp.top
                if let last = last {
                    top = last.snp.bottom
                }
                button.snp.makeConstraints { maker in
                    maker.width.equalTo(self.snp.width)
                    maker.height.equalTo(view.snp.height).dividedBy(count)
                    maker.top.equalTo(top)
                }
                last = button
            }
        }
    }

    @objc private func onClick(sender: UIButton) {
        let index = sender.tag
        delegate?.onCheck(index: index)
        selectItem(index)
    }

    public func setDelegate(delegate: GripDelegate) {
        self.delegate = delegate
    }

    public func selectItem(_ index: Int) {
        for v in self.subviews {
            if (v.tag == index) {
                if Setting.getUseTheme() == 1 {
                    v.backgroundColor = UIColor(white: 0, alpha: 0)
                } else {
                    v.backgroundColor = ViewController.DEFAULT_BACKGROUND
                }
            } else {
                if Setting.getUseTheme() == 1 {
                    v.backgroundColor = UIColor(white: 0, alpha: 0)
                } else {
                    v.backgroundColor = UIColor.clear
                }
            }
        }
    }

}
