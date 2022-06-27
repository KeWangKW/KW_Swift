
//  BHPPDListCell.swift
//  KW_Swift
//
//  Created by 渴望 on 2021/4/16.
//  Copyright © 2021 guan. All rights reserved.
//

import UIKit

class BHPPDListCellItem: KWCollectionViewCellItem {
    override var cellSize: CGSize {
        get {
            return CGSize(width: (KScreenWidth-28)/2, height: KScreenWidth*0.69)
        } set{}
    }
    var showTag:Bool = true
}

class BHPPDListCell: KWCollectionViewCell {
//MARK: 获取数据
    override var item: KWCollectionViewCellItem!{
        didSet{
            //let i = item as! BHPPDListCellItem
            let mo = item.cellModel as! BPDDDModel
            
            extraLab.text = "【\(mo.name)】"
        }
    }
    
    
    override func kw_setupViews() {
        super.kw_setupViews()
        self.backgroundColor = .random
        
        addSubview(extraLab)
        
    }
    
    override func kw_setupLayouts() {
        super.kw_setupLayouts()
        
        extraLab.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    

    
    private lazy var extraLab:UILabel = {
        let lab = UILabel()
        lab.font = .medium(size: 16)
        lab.text = "0"
        lab.textColor = UIColor.init(hexString: "FFE6BC")
        return lab
    }()
    
}
