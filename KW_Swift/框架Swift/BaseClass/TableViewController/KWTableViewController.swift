//
//  KWTableViewController.swift
//  BaseSwift
//
//  Created by 渴望 on 2019/6/28.
//  Copyright © 2019 渴望. All rights reserved.
//

import UIKit

class KWTableViewController: KWViewController {
    
    //默认sectionHeader不悬停 可在【kw_setupData】中修改
    public var style: UITableView.Style = .plain
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    // MARK: - Base Class
    override func kw_setupData() {
        super.kw_setupData()
        
    }
    
    override func kw_setupUI() {
        super.kw_setupUI()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide)
            } else {
                make.edges.equalToSuperview()
            }
        }
    }
    
    // MARK: - ConfigureData 初始化数据
    func kw_configureData() -> Void {}
    func kw_configureData<T: KWModel>(model: T?) -> Void {}
    
    // MARK: - lazy
    lazy var tableView: UITableView =  {
        let table = UITableView.init(frame: CGRect(), style: style)
        table.dataSource = self
        table.delegate = self
        table.emptyDataSetSource = self
        table.emptyDataSetDelegate = self
        table.backgroundColor = .custom(.section)
        table.separatorStyle = .none
        table.tableFooterView = UIView()
        table.tableHeaderView = UIView.init(frame: CGRect.init(origin: .zero, size: CGSize(width: 1, height: CGFloat.leastNormalMagnitude)))
        table.estimatedSectionHeaderHeight = 0
        table.estimatedSectionFooterHeight = 0
        if #available(iOS 11.0, *) {
            table.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        if #available(iOS 15.0, *) {
            table.sectionHeaderTopPadding = 0
        }
        table.kw.register(cell: KWTableViewCell.self)
        return table
    }()
    
    lazy var dataArr: [[KWTableViewCellItem]] = {
        let datas = [[KWTableViewCellItem]]()
        return datas
    }()
    
    lazy var Section0Arr: [KWTableViewCellItem] = {
        let section = [KWTableViewCellItem]()
        return section
    }()
    
    lazy var Section1Arr: [KWTableViewCellItem] = {
        let section = [KWTableViewCellItem]()
        return section
    }()
    
    lazy var Section2Arr: [KWTableViewCellItem] = {
        let section = [KWTableViewCellItem]()
        return section
    }()
    
    lazy var Section3Arr: [KWTableViewCellItem] = {
        let section = [KWTableViewCellItem]()
        return section
    }()
    
    lazy var Section4Arr: [KWTableViewCellItem] = {
        let section = [KWTableViewCellItem]()
        return section
    }()
    
    lazy var Section5Arr: [KWTableViewCellItem] = {
        let section = [KWTableViewCellItem]()
        return section
    }()
    
    lazy var Section6Arr: [KWTableViewCellItem] = {
        let section = [KWTableViewCellItem]()
        return section
    }()
    lazy var Section7Arr: [KWTableViewCellItem] = {
        let section = [KWTableViewCellItem]()
        return section
    }()
    lazy var Section8Arr: [KWTableViewCellItem] = {
        let section = [KWTableViewCellItem]()
        return section
    }()
    lazy var Section9Arr: [KWTableViewCellItem] = {
        let section = [KWTableViewCellItem]()
        return section
    }()
}


extension KWTableViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = dataArr[indexPath.section][indexPath.row]
        let cell = tableView.kw.dequeue(cell: item.cellClass, for: indexPath) as! KWTableViewCell
//        let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! KWTableViewCell
        cell.item = item
        
        cell.delegate = self
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item: KWTableViewCellItem = dataArr[indexPath.section][indexPath.row]
        return item.cellHeight > 0 ? item.cellHeight : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .custom(.section)
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .custom(.section)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension KWTableViewController: KWTableViewCellDelegate {
}
