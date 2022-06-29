//
//  ShopCartVC.swift
//  KW_Swift
//
//  Created by 渴望 on 2021/11/30.
//  Copyright © 2021 guan. All rights reserved.
//

import UIKit

class ShopCartVC: KWPageTableViewListGroupController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: kw_setupData
    override func kw_setupData() {
        super.kw_setupData()
        self.isAddRefreshFooter = true
        kw.emptyDataSetImage = UIImage(named: "ic_zeroshuj")
        kw.emptyDataSetTitle = "空空如也"
    }
    //MARK: kw_setupUI
    override func kw_setupUI() {
        super.kw_setupUI()
        
    }
    
    //MARK: kw_requestData
    override func kw_requestData() {
        super.kw_requestData()
        
    }

}

    
    


