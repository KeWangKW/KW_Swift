//
//  IBaseView.swift
//  IPickerView
//
//  Created by Leblanc on 2021/2/26.
//

import Foundation
import UIKit

class IBaseView: UIView {
    
    /**弹框视图*/
    var alertView: UIView!
    
    /// 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    /// 初始化UI
    func initUI() {
        self.backgroundColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.2)
        self.frame = UIScreen.main.bounds
        alertView = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 216))
        alertView.backgroundColor = .cyan
        addSubview(alertView)
    }
    
    
    /// 点击视图事件，移除alertView
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch.view != self.alertView {
                self.removePickerView()
            }
        }
    }
    
    
    /// 添加视图方法
    func addPickerView() {
        initUI()
        IPickerViewMacro.keyWindow().addSubview(self)
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
            self.alertView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 216, width: self.alertView.frame.width, height: 216)
        }
    }
    
    /// 移除视图方法
    func removePickerView() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0
            let alertY = self.alertView.frame.size.height + UIScreen.main.bounds.height
            self.alertView.frame = CGRect(x: 0, y: alertY, width: self.alertView.frame.width, height: 216)
        } completion: { (finish) in
            self.removeFromSuperview()
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
