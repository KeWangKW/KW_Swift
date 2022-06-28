//
//  WTableVieC.swift
//  KW_Swift
//
//  Created by 渴望 on 2022/6/28.
//  Copyright © 2022 guan. All rights reserved.
//

import UIKit

class WTableVieCItem: KWTableViewCellItem {
    override var cellHeight: CGFloat {get{100} set{}}
}

class WTableVieC: KWTableViewCell {

    override var item: KWTableViewCellItem!{
        didSet{
            let i = item as! WTableVieCItem
            
        }
    }
    
    override func kw_setupViews() {
        super.kw_setupViews()
        self.backgroundColor = .random
    }
    
    override func kw_setupLayouts() {
        super.kw_setupLayouts()
        
    }
    
}
