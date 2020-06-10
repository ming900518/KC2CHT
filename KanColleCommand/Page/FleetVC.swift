//
// Created by CC on 2019-02-16.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

class FleetVC: UIViewController {

    private let cellIdentifier = "ShipCellId"
    private var shipIds = Array<Int>()
    private var currIndex = 0
    private let indicatorSize = CGSize(width: 32, height: 64)

    private var shipListView: UITableView!
    private var indicatorList = Array<UIButton>()
    private var fleetHint: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        if Setting.getUseTheme() == 0 {
            self.view.backgroundColor = ViewController.DEFAULT_BACKGROUND
        } else {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        }
        setupList()
        setupIndicator()
        watchShipMap()
        onSelect(index: 0)
    }

    private func setupList() {
        fleetHint = UILabel()
        fleetHint.textColor = UIColor.white
        fleetHint.font = UIFont.systemFont(ofSize: 12)
        fleetHint.textAlignment = .center
        self.view.addSubview(fleetHint)
        shipListView = UITableView()
        shipListView.delegate = self
        shipListView.dataSource = self
        shipListView.backgroundColor = UIColor.clear
        shipListView.separatorStyle = .none
        shipListView.register(ShipCell.self, forCellReuseIdentifier: cellIdentifier)
        self.view.addSubview(shipListView)
        shipListView.snp.makeConstraints { maker in
            maker.left.equalTo(self.view.snp.left).offset(8)
            maker.right.equalTo(self.view.snp.right).offset(-48)
            maker.top.equalTo(self.view.snp.top).offset(4)
            maker.bottom.equalTo(self.view.snp.bottom).offset(-4)
        }
        fleetHint.snp.makeConstraints { maker in
            maker.left.equalTo(shipListView.snp.left).offset(8)
            maker.right.equalTo(shipListView.snp.right).offset(-8)
            maker.top.equalTo(shipListView.snp.bottom).inset(24)//.offset(8)
        }
    }

    private func setupIndicator() {
        let indicatorContainer = UIStackView()
        for i in 0...3 {
            let item = UIButton(type: .custom)
            item.tag = i
            item.setTitle("\(i + 1)", for: .normal)
            item.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            item.addTarget(self, action: #selector(onIndicatorItemClick), for: .touchUpInside)
            indicatorContainer.addArrangedSubview(item)
            item.snp.makeConstraints { maker in
                maker.width.equalTo(indicatorSize.width)
                maker.height.equalTo(indicatorSize.height)
            }
            indicatorList.append(item)
        }
        indicatorContainer.axis = .vertical
        indicatorContainer.distribution = .fillEqually
        indicatorContainer.alignment = .center
        indicatorContainer.spacing = 4
        self.view.addSubview(indicatorContainer)
        indicatorContainer.snp.makeConstraints { maker in
            maker.right.equalTo(self.view.snp.right).offset(-8)
            maker.centerY.equalTo(shipListView.snp.centerY)
        }
    }

    @objc private func onIndicatorItemClick(sender: UIButton) {
        currIndex = sender.tag
        invalidateIndicator()
        onSelect(index: currIndex)
    }

    private func onSelect(index: Int) {
        print(index)
        do {
            shipIds = try Fleet.instance.deckShipIds[index].value().filter { (i: Int) -> Bool in
                i > 0
            }
        } catch {
            print("Error when call onSelect(\(index)")
        }
        shipListView.reloadData()
        var hintText: String
        if (shipIds.count > 0) {
            let level = Fleet.instance.getFleetLevel(index: index)
            var speed = "高速"
            if (Fleet.instance.getFleetSpeedType(index: index) == .SLOW) {
                speed = "低速"
            }
            let airPower = Fleet.instance.getFleetAirPower(index: index)
            let scout = floor(Fleet.instance.getFleetScout(index: index) * 100) / 100
            hintText = "Lv. \(level) / \(speed) / 制空：\(airPower[0])-\(airPower[1]) / 索敵：\(scout)"
        } else {
            hintText = ""
        }
        fleetHint.text = hintText
    }

    private func watchShipMap() {
        Oyodo.attention().watch(data: Fleet.instance.shipWatcher) { (event: Event<Transform>) in
            self.invalidateIndicator()
            self.onSelect(index: self.currIndex)
        }
        Fleet.instance.deckShipIds.forEach { it in
            Oyodo.attention().watch(data: it) { (event: Event<Array<Int>>) in
                self.invalidateIndicator()
                self.onSelect(index: self.currIndex)
            }
        }
    }

    private func invalidateIndicator() {
        for (index, button) in indicatorList.enumerated() {
            if (index == currIndex) {
                button.setBackgroundImage(getSelectedIndicator(index: index, size: indicatorSize), for: .normal)
            } else {
                button.setBackgroundImage(getUnselectedIndicator(index: index, size: indicatorSize), for: .normal)
            }
        }
    }

}

extension FleetVC: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        tableView.deselectRow(at: indexPath, animated: false)
        return nil
    }

}

extension FleetVC: UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shipIds.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: ShipCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ShipCell
        if cell == nil {
            cell = ShipCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        cell.set(id: shipIds[indexPath.item])
        return cell
    }

}

private class ShipCell: UITableViewCell {

    private var hp: HpBar!
    private var slots: Array<UIImageView>!
    private var slotEx: UIImageView!
    private var nameText: UILabel!
    private var levelText: UILabel!
    private var condText: UILabel!
    private var hpText: UILabel!
    private var statusTag: UIImageView!

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = UIColor.clear

        let root = UIView()
        addSubview(root)
        root.snp.makeConstraints { maker in
            maker.left.equalTo(self)
            maker.top.equalTo(self)
            maker.bottom.equalTo(self).offset(-4)
            maker.right.equalTo(self)
        }

        // HP Bar
        hp = HpBar()
        hp.attachTo(cell: root)

        // Slot
        slots = Array<UIImageView>()
        var lastSlotView: UIView? = nil
        for _ in (0...4) {
            let slotIcon = UIImageView()
            root.addSubview(slotIcon)
            var rightConstraint: ConstraintItem
            if let view = lastSlotView {
                rightConstraint = view.snp.left
            } else {
                rightConstraint = root.snp.right
            }
            slotIcon.snp.makeConstraints { maker in
                maker.width.equalTo(24)
                maker.height.equalTo(24)
                maker.top.equalTo(root.snp.top).offset(4)
                maker.right.equalTo(rightConstraint).offset(-4)
            }
            slotIcon.contentMode = .scaleAspectFill
            slots.append(slotIcon)
            lastSlotView = slotIcon
        }
        slots.reverse()

        // Name
        nameText = UILabel()
        root.addSubview(nameText)
        nameText.snp.makeConstraints { maker in
            maker.left.equalTo(root.snp.left).offset(8)
            maker.top.equalTo(root.snp.top).offset(4)
            maker.width.equalTo(140)
        }
        nameText.numberOfLines = 1
        nameText.lineBreakMode = .byTruncatingTail
        nameText.font = UIFont.systemFont(ofSize: 15)
        nameText.textColor = UIColor.white

        // Level
        levelText = UILabel()
        root.addSubview(levelText)
        levelText.snp.makeConstraints { maker in
            maker.left.equalTo(nameText.snp.left)
            maker.top.equalTo(nameText.snp.bottom).offset(4)
            maker.bottom.equalTo(root.snp.bottom).offset(-4)
            maker.width.equalTo(50)
        }
        levelText.numberOfLines = 1
        levelText.lineBreakMode = .byTruncatingTail
        levelText.font = UIFont.systemFont(ofSize: 12)
        levelText.textColor = UIColor.lightGray

        // Cond
        condText = UILabel()
        root.addSubview(condText)
        condText.snp.makeConstraints { maker in
            maker.top.equalTo(lastSlotView!.snp.bottom).offset(4)
            maker.right.equalTo(root.snp.right).offset(-4)
            maker.bottom.equalTo(root.snp.bottom).offset(-4)
            maker.width.equalTo(40)
        }
        condText.numberOfLines = 1
        condText.lineBreakMode = .byTruncatingTail
        condText.font = UIFont.systemFont(ofSize: 12)
        condText.textAlignment = .right

        // HP Text
        hpText = UILabel()
        root.addSubview(hpText)
        hpText.snp.makeConstraints { maker in
            maker.left.equalTo(root.snp.right).offset(-136)
            maker.top.equalTo(levelText.snp.top)
        }
        hpText.numberOfLines = 1
        hpText.lineBreakMode = .byTruncatingTail
        hpText.font = UIFont.systemFont(ofSize: 12)
        hpText.textColor = UIColor.lightGray

        // Status tag
        statusTag = UIImageView()
        root.addSubview(statusTag)
        statusTag.snp.makeConstraints { maker in
            maker.width.equalTo(16)
            maker.height.equalTo(16)
            maker.centerY.equalTo(levelText.snp.centerY)
            maker.left.equalTo(levelText.snp.right).offset(8)
        }

        // Slot ex
        slotEx = UIImageView()
        root.addSubview(slotEx)
        slotEx.snp.makeConstraints { maker in
            maker.width.equalTo(16)
            maker.height.equalTo(16)
            maker.right.equalTo(condText.snp.left).offset(-12)
            maker.centerY.equalTo(condText.snp.centerY)
        }

        // Divider
        //let divider = UIView()
        //addSubview(divider)
        //divider.snp.makeConstraints { maker in
            //maker.width.equalTo(self)
            //maker.height.equalTo(4)
            //maker.bottom.equalTo(self)
        //}
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(id: Int) {
        if let ship = Fleet.instance.shipMap[id] {
            hp.set(percent: CGFloat(ship.hp()) / CGFloat(ship.maxHp))
            for (index, slotView) in slots.enumerated() {
                var image = UIImage.init(named: "slot_0.png")
                if let slotId = ship.items[safe: index] {
                    if let slotItem = Fleet.instance.slotMap[slotId] {
                        let slotType = slotItem.type
                        image = UIImage.init(named: "slot_\(slotType).png")
                    }
                }
                slotView.image = image
            }
            nameText.text = ship.name
            levelText.text = "Lv. \(ship.level)"
            condText.text = "★\(ship.condition)"
            condText.textColor = getConditionColor(cond: ship.condition)
            hpText.text = "\(max(ship.hp(), 1)) / \(ship.maxHp)"
            statusTag.image = getTagImage(shipId: ship.id)
            //if Fleet.instance.slotMap[ship.itemEx] != nil {
            if let exItem = Fleet.instance.slotMap[ship.itemEx] {
                slotEx.image = UIImage.init(named: "slot_\(exItem.type).png")
            }
            else {
                slotEx.image = UIImage.init(named: "slot_0.png")
            }
        } else {
            hp.set(percent: 0)
            slots.forEach { slot in
                slot.image = UIImage.init(named: "slot_0.png")
            }
            nameText.text = ""
            levelText.text = ""
            condText.text = ""
            hpText.text = ""
            statusTag.image = nil
            slotEx.image = UIImage.init(named: "slot_0.png")
        }
    }
}
