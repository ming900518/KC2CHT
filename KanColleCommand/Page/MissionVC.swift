//
// Created by CC on 2019-04-24.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

class MissionVC: UIViewController {

    private let cellIdentifier = "MissionCellId"

    private var missionListView: UITableView!
    private var questList = Array<Quest>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ViewController.DEFAULT_BACKGROUND
        setupList()
        Oyodo.attention().watch(data: Mission.instance.questMap) { (event: Event<Dictionary<Int, Quest>>) in
            if let map = event.element {
                var list = map.values.filter { quest in
                    quest.state >= 2
                }
                list.sort { quest, quest2 in
                    quest.id < quest2.id
                }
                self.questList = list
                self.missionListView.reloadData()
            }
        }
    }

    private func setupList() {
        missionListView = UITableView()
        missionListView.delegate = self
        missionListView.dataSource = self
        missionListView.backgroundColor = UIColor.clear
        missionListView.separatorStyle = .none
        missionListView.register(MissionCell.self, forCellReuseIdentifier: cellIdentifier)
        self.view.addSubview(missionListView)
        missionListView.snp.makeConstraints { maker in
            maker.left.equalTo(self.view.snp.left).offset(8)
            maker.right.equalTo(self.view.snp.right).offset(-32)
            maker.top.equalTo(self.view.snp.top).offset(8)
            maker.bottom.equalTo(self.view.snp.bottom).offset(-8)
        }
    }

}

extension MissionVC: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        tableView.deselectRow(at: indexPath, animated: false)
        return nil
    }

}

extension MissionVC: UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questList.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: MissionCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? MissionCell
        if cell == nil {
            cell = MissionCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        cell.set(questList[indexPath.item])
        return cell
    }

}

private class MissionCell: UITableViewCell {

    private var indicator: UIView!
    private var title: UILabel!
    private var summary: UILabel!
    private var progress: UILabel!

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = UIColor.clear

        indicator = UIView()
        addSubview(indicator)
        indicator.snp.makeConstraints { maker in
            maker.width.equalTo(12)
            maker.height.equalTo(12)
            maker.left.equalTo(self.snp.left).offset(16)
            maker.top.equalTo(self.snp.top).offset(16)
        }

        progress = UILabel()
        progress.numberOfLines = 1
        progress.lineBreakMode = .byTruncatingTail
        progress.font = UIFont.systemFont(ofSize: 14)
        progress.textColor = UIColor.lightGray
        addSubview(progress)
        progress.snp.makeConstraints { maker in
            maker.right.equalTo(self.snp.right).offset(-16)
            maker.centerY.equalTo(indicator.snp.centerY)
            maker.width.equalTo(32)
        }

        title = UILabel()
        title.numberOfLines = 1
        title.lineBreakMode = .byTruncatingTail
        title.font = UIFont.systemFont(ofSize: 16)
        title.textColor = UIColor.white
        addSubview(title)
        title.snp.makeConstraints { maker in
            maker.left.equalTo(indicator.snp.right).offset(8)
            maker.right.equalTo(progress.snp.left).offset(-8)
            maker.centerY.equalTo(indicator.snp.centerY)
        }

        summary = UILabel()
        summary.numberOfLines = 2
        summary.lineBreakMode = .byTruncatingTail
        summary.font = UIFont.systemFont(ofSize: 14)
        summary.textColor = UIColor.lightGray
        addSubview(summary)
        summary.snp.makeConstraints { maker in
            maker.left.equalTo(title.snp.left)
            maker.right.equalTo(progress.snp.right)
            maker.top.equalTo(title.snp.bottom).offset(4)
            maker.bottom.equalTo(self.snp.bottom).offset(-8)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func set(_ data: Quest) {
        indicator.backgroundColor = getQuestIndicatorColor(type: data.category)
        title.text = data.title
        summary.text = data.description
        if (data.max == 0) {
            progress.text = ""
        } else {
            progress.text = "\(data.current)/\(data.max)"
        }
    }

}
