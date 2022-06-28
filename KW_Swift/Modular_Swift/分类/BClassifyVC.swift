//
//  ZMessageVC.swift
//  KW_Swift
//
//  Created by 渴望 on 2020/12/8.
//  Copyright © 2020 渴望. All rights reserved.
//

import UIKit

class BClassifyVC: KWTableViewController {
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    //MARK: kw_setupData
    override func kw_setupData() {
        super.kw_setupData()
        style = .plain
    }
    //MARK: kw_setupUI
    override func kw_setupUI() {
        super.kw_setupUI()
        tableView.kw.registerXib(cellXib: WTableVieC.self)
//        tableView.kw.register(cell: WTableVieC.self)
    }
    //MARK: kw_requestData
    override func kw_requestData() {
        super.kw_requestData()
        
        
        let v = UIView(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight/10))
        v.backgroundColor = .red
        tableView.tableHeaderView = v
        
        for idx in 0...10 {
            let item = WTableVieCItem()
            Section0Arr.append(item)
        }
        
        dataArr.append(Section0Arr)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = .Orange
        return v
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.tableViewCornerRadius(tableView: tableView, cellCornerRadius: 20, forRowAt: indexPath)
//    }
    
    
}
