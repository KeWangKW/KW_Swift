//
//  ZProjectManagerVC.swift
//  KW_Swift
//
//  Created by 渴望 on 2020/12/8.
//  Copyright © 2020 渴望. All rights reserved.
//

import UIKit

class BHomePageVC: KWCollectionRefreshViewController  {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nav_color_clear()
        self.fd_prefersNavigationBarHidden = true
        
    }
    
    override func kw_setupData() {
        super.kw_setupData()
        
        kw.emptyDataSetTitle = ""
        kw.emptyDataSetImage = UIImage()
    }
    
    override func kw_setupUI() {
        super.kw_setupUI()
        
    }
    
    override func kw_requestData() {
        super.kw_requestData()
        
    }
    
}
