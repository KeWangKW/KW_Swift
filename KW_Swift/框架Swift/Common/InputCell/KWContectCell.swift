//
//  KWContectCell.swift
//  KW_Swift
//
//  Created by 渴望 on 2020/12/14.
//  Copyright © 2020 渴望. All rights reserved.
//

import UIKit

class KWContectCellItem: KWTableViewCellItem {
    override var cellHeight: CGFloat {
        get { 45 } set{}
    }
    
    var titColor:UIColor = .Title
    var titFont:CGFloat = 15
    
    var msg:String = ""
    var msgColor:UIColor = .Title
    var msgFont:CGFloat = 15
    
    var isStarHide: Bool = true
}

class KWContectCell: KWTableViewCell {

    override var item: KWTableViewCellItem!{
        didSet {
            let i = item as! KWContectCellItem
            
            self.titleLab.text = i.title
            self.titleLab.textColor = i.titColor
            self.titleLab.font = .systemFont(ofSize: i.titFont)
            self.msgLab.text = i.msg
            self.msgLab.textColor = i.msgColor
            self.msgLab.font = .systemFont(ofSize: i.msgFont)
            
            if i.isStarHide{
                titleLab.snp.makeConstraints { (make) in
                    make.left.equalTo(CellPadding+7)
                    make.centerY.equalToSuperview()
                }
                starLabel .isHidden = true
            }else{
               
                starLabel .isHidden = false
               
            }
           
            separatorLabel.isHidden = item.isShowBtmLine
        }
    }
    
    override func kw_setupViews() {
        super.kw_setupViews()
        addSubview(titleLab)
        addSubview(msgLab)
        addSubview(starLabel)
        self.selectionStyle = .none
    }

    override func kw_setupLayouts() {
        super.kw_setupLayouts()
        titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(starLabel.snp.right)
            make.centerY.equalToSuperview()
        }
        msgLab.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        starLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(15)
        }
    }
    private lazy var starLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = .systemFont(ofSize: 14)
        label.text = "*"
        return label
    }()
    private lazy var titleLab:UILabel  = {
        let lab = UILabel()
        lab.font = .systemFont(ofSize: 15)
        return lab
    }()
    private lazy var msgLab:UILabel  = {
        let lab = UILabel()
        lab.font = .systemFont(ofSize: 15)
        lab.textColor = .Assist
        lab.numberOfLines = 0
        lab.textAlignment = .right
        return lab
    }()
}
