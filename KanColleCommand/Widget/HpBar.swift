//
// Created by CC on 2019-02-16.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class HpBar: UIView {

    private var unreachedView: UIView!
    private var reachedView: UIView!

    init() {
        super.init(frame: CGRect.zero)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public func attachTo(cell: UIView) {
        cell.addSubview(self)
        self.snp.makeConstraints { maker in
            maker.edges.equalTo(cell)
        }
        unreachedView = UIView()
        unreachedView.backgroundColor = UIColor.init(red: 0.282, green: 0.282, blue: 0.282, alpha: 1)
        addSubview(unreachedView)
        unreachedView.snp.makeConstraints { maker in
            maker.right.equalTo(self.snp.right)
            maker.height.equalTo(self.snp.height)
            maker.width.equalTo(self.snp.width)
        }
        reachedView = UIView()
        reachedView.backgroundColor = UIColor.clear
        addSubview(reachedView)
        reachedView.snp.makeConstraints { maker in
            maker.left.equalTo(self.snp.left)
            maker.height.equalTo(self.snp.height)
            maker.width.equalTo(0)
        }
    }

    public func set(percent: CGFloat) {
        unreachedView.snp.remakeConstraints { maker in
            maker.right.equalTo(self.snp.right)
            maker.height.equalTo(self.snp.height)
            maker.width.equalTo(self.snp.width).multipliedBy(1 - percent)
        }
        reachedView.snp.remakeConstraints { maker in
            maker.left.equalTo(self.snp.left)
            maker.height.equalTo(self.snp.height)
            maker.width.equalTo(self.snp.width).multipliedBy(percent)
        }
        reachedView.backgroundColor = getShipHpColor(percent: percent)
    }

}
