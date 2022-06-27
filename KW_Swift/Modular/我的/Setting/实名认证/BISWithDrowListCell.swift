//
//  BISWithDrowListCell.swift
//  KW_Swift
//
//  Created by 渴望 on 2021/4/27.
//  Copyright © 2021 guan. All rights reserved.
//

import UIKit

class BISWithDrowListCellItem: KWTableViewCellItem {
    override var cellHeight: CGFloat {get{70} set{}}
    var isSpmUse:Bool = false
    var is_TGG:Bool = false
}

class BISWithDrowListCell: KWTableViewCell {

    override var item: KWTableViewCellItem!{
        didSet{
            let i = item as! BISWithDrowListCellItem
            let mo = item.cellModel as! BISWDModel
            
            if mo.status == "3" {
                imgv.image = UIImage(named: "cuo")
            }else{
                imgv.image = UIImage(named: "dui")
            }
            titleLab.text = "\(mo.bank)"
            timeLab.text = mo.add_time
            moneyLab.text = "\(mo.amount)元"
            statusLab.text = mo.status_text
            
            if i.isSpmUse {
                if mo.collection_type == "1" {
                    imgv.image = UIImage(named: "支付宝")
                }else{
                    imgv.image = UIImage(named: "银行卡")
                }
                titleLab.text = mo.payChannelName
            }
            
            if i.is_TGG {
                titleLab.text = mo.payChannelName + "提现"
                statusLab.text = ""
            }
        }
    }
    
    override func kw_setupViews() {
        super.kw_setupViews()
        self.selectionStyle = .none
        self.separatorLabel.isHidden = true
        self.backgroundColor = .Section
        
    }
    
    override func kw_setupLayouts() {
        super.kw_setupLayouts()
        
    }
    //支 付 宝
    //银行卡-1
    @IBOutlet weak var imgv: UIImageView!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var timeLab: UILabel!
    @IBOutlet weak var moneyLab: UILabel!
    @IBOutlet weak var statusLab: UILabel!
    
    
    
}
