//
//  CartListPageVC.swift
//  KW_Swift
//
//  Created by 渴望 on 2021/11/30.
//  Copyright © 2021 guan. All rights reserved.
//

import UIKit
import JXSegmentedView

class CartListPageVC: KWPageNavController {

    func defaultSelectedIndex(_ idx:Int) {
        self.segmentedView.selectItemAt(index: idx)
        editBtn.isHidden = idx == 0 ? false:true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = ""
    }
    
    //MARK: kw_setupData
    let vc1 = ShopCartVC()
    let vc2 = PackageClipVC()
    override func kw_setupData() {
        super.kw_setupData()
        
        self.titles = ["购物车", "方案夹",]
        self.controllers = [
            vc1,
            vc2
        ]
        
    }
    //MARK: kw_setupUI
    override func kw_setupUI() {
        super.kw_setupUI()
        
        view.addSubview(editBtn)
        editBtn.snp.makeConstraints { make in
            make.size.equalTo(KNavigationBarHeight)
            make.right.equalTo(-8)
            make.top.equalTo(KStatusBarHeight)
        }
    }
    //MARK: kw_requestData
    override func kw_requestData() {
        super.kw_requestData()
        vc1.kw_refreshData()
        vc2.kw_refreshData()
    }
    
    override func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "编辑", style: .plain, target: self, action: #selector(editClick))
        editBtn.isHidden = index == 0 ? false:true
    }
    
    private lazy var editBtn:UIButton = {
        let btn = UIButton()
        //btn.backgroundColor = .red
        btn.setTitle("编辑", for: .normal)
        btn.setTitle("完成", for: .selected)
        btn.titleLabel?.font = .systemFont(ofSize: 15)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(editClick), for: .touchUpInside)
        return btn
    }()
    @objc func editClick() {
        editBtn.isSelected = !editBtn.isSelected
        
    }
    
}
