//
//  WPMShopMsgResultVC.swift
//  KW_Swift
//
//  Created by 渴望 on 2021/7/13.
//  Copyright © 2021 guan. All rights reserved.
//

import UIKit

class WPMShopMsgResultVC: KWTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "店铺信息"
        // Do any additional setup after loading the view.
    }


    //MARK: kw_setupData
    override func kw_setupData() {
        super.kw_setupData()
        
    }
    //MARK: kw_setupUI
    override func kw_setupUI() {
        super.kw_setupUI()
        
        tableView.kw.registerXib(cellXib: WPMShopMsgResultOneCell.self)
        tableView.kw.registerXib(cellXib: WPMShopMsgResultTwoCell.self)
        tableView.snp.remakeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(100)
        }
    }
    //MARK: kw_requestData
    override func kw_requestData() {
        super.kw_requestData()
        
        let item = WPMShopMsgResultOneCellItem()
        Section0Arr.append(item)
        
        let item2 = WPMShopMsgResultTwoCellItem()
        Section0Arr.append(item2)
        
        dataArr.append(Section0Arr)
        self.tableView.reloadData()
    }

}
