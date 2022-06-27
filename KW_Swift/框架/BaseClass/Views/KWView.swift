//
//  KWView.swift
//  BaseSwift
//
//  Created by 渴望 on 2020/5/22.
//  Copyright © 2020 渴望. All rights reserved.
//

import UIKit

typealias  BlockBtnClick = (Any) ->() //1.声明闭包
typealias  BlockStrClick = (String) ->()
class KWView: UIView {
    
    var BtnBlock : BlockBtnClick? //2.闭包声明称属性
    func btnClick(jumpbtnClickBlock:@escaping BlockBtnClick) -> Void { //3.实现方法
        BtnBlock = jumpbtnClickBlock;
    }
    var StrBlock : BlockStrClick? //2.闭包声明称属性
    func strClick(jumpbtnClickBlock:@escaping BlockStrClick) -> Void { //3.实现方法
        StrBlock = jumpbtnClickBlock;
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        kw_setupViews()
        kw_setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func kw_setupViews()  {
        backgroundColor = .custom(.backgroundWhite)
    }
    
    public func kw_setupLayouts() {
        
    }
    
}
