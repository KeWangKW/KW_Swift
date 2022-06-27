//
//  WPMShopMsgResultOneCell.swift
//  KW_Swift
//
//  Created by 渴望 on 2021/7/13.
//  Copyright © 2021 guan. All rights reserved.
//

import UIKit

class WPMShopMsgResultOneCellItem: KWTableViewCellItem {
    override var cellHeight: CGFloat {get{560} set{}}
}

class WPMShopMsgResultOneCell: KWTableViewCell {
    @IBOutlet weak var jianchengView: UIView!
    @IBOutlet weak var TopToBottom: NSLayoutConstraint!
    @IBOutlet weak var fenleiView: UIView!
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var hangyeTF: UITextField!
    @IBOutlet weak var jianchengTF: UITextField!
    @IBOutlet weak var fenleiTF: UITextField!
    @IBOutlet weak var personTF: UITextField!
    @IBOutlet weak var timeTF: UITextField!
    @IBOutlet weak var xiaofeiTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var telTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var areaTF: UITextField!
    @IBOutlet weak var menpaihaoTF: UITextField!
    
    override var item: KWTableViewCellItem!{
        didSet{
            let i = item as! WPMShopMsgResultOneCellItem
            
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
