//
//  WPMShopMsgResultTwoCell.swift
//  KW_Swift
//
//  Created by 渴望 on 2021/7/13.
//  Copyright © 2021 guan. All rights reserved.
//

import UIKit

class WPMShopMsgResultTwoCellItem: KWTableViewCellItem {
    override var cellHeight: CGFloat {get{165} set{}}
}

class WPMShopMsgResultTwoCell: KWTableViewCell {
    @IBOutlet weak var LImgV: UIImageView!
    @IBOutlet weak var RImgV: UIImageView!
    
    override var item: KWTableViewCellItem!{
        didSet{
            let i = item as! WPMShopMsgResultTwoCellItem
            
        }
    }
    
    override func kw_setupViews() {
        super.kw_setupViews()
        self.backgroundColor = .Section
        self.selectionStyle = .none
        self.separatorLabel.isHidden = true
        
    }
    
    override func kw_setupLayouts() {
        super.kw_setupLayouts()
        
    }
    
}
