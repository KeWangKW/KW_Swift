//
//  ZSearchView.swift
//  KW_Swift
//
//  Created by 渴望 on 2020/12/21.
//  Copyright © 2020 渴望. All rights reserved.
//

import UIKit

class ZSearchView: KWView {
    
    func setPlaceHolder (placrHolder:String) {
        searchTF.placeholder = placrHolder
    }
    
    override func kw_setupViews() {
        super.kw_setupViews()
        self.frame = CGRect(x: 0, y: 0, width: KScreenWidth, height: 60)
        addSubview(searchTF)
    }
    override func kw_setupLayouts() {
        super.kw_setupLayouts()
        searchTF.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
        }
    }

    private lazy var searchTF:UITextField = {
        let tf = UITextField()
        tf.placeholder = "请输入"
        tf.font = .systemFont(ofSize: 15)
        tf.backgroundColor = .Section
        tf.layer.masksToBounds = true
        tf.layer.cornerRadius = 20
        
        tf.leftView = {
            let container = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
            let lab = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
            lab.text = "🔍"
            lab.textAlignment = .center
            container.addSubview(lab)
            return container
        }()
        tf.leftViewMode = .always
        tf.rightViewMode = .always
        tf.rightView = {
            let container = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
            let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
            btn.setTitle("搜索", for: .normal)
            btn.setTitleColor(.Orange, for: .normal)
            btn.titleLabel?.font = .systemFont(ofSize: 15)
            btn.addTarget(self, action: #selector(searchClick), for: .touchUpInside)
            container.addSubview(btn)
            return container
        }()
        
        return tf
    }()
    
    @objc func searchClick() {
        self.StrBlock?(searchTF.text ?? "")
    }
}
