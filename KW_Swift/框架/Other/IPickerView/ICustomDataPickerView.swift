//
//  ICustomDataPickerView.swift
//  IPickerView
//
//  Created by Leblanc on 2021/2/26.
//  自定义数据源选择

import Foundation
import UIKit

/// 声明选中结果闭包
typealias resultCallBack = (_ text: String ,_ index: Int ) -> Void
class ICustomDataPickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    /**自定义数据源*/
    lazy var dataSource: [String] = [] {
        didSet {
            pickerView.reloadAllComponents()
        }
    }
    /**弹框视图*/
    var alertView: UIView!
    /**左边取消按钮*/
    var cancleBtn: UIButton!
    /**右边确定按钮*/
    var confirmBtn: UIButton!
    /**中间标题*/
    var titleLabel: UILabel!
    /**选择器*/
    var pickerView: UIPickerView!
    /**确定回调事件*/
    var resultBlock: resultCallBack?
    /**滚动的列index*/
    var currentIndex: Int = 0
    
    /// 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.2)
        self.frame = UIScreen.main.bounds
        
        setUpSubViews()
    }
    
    /// 设置子控件
    func setUpSubViews() {
        
        /**弹框视图*/
        alertView = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 260 + IPickerViewMacro.safeBottomHeight))
        alertView.backgroundColor = .white
        addSubview(alertView)
        
        /**左边取消按钮*/
        cancleBtn = UIButton(type: .custom)
        cancleBtn.frame = CGRect(x: 5, y: 8, width: 60, height: 28)
        cancleBtn.setTitle("取消", for: .normal)
        cancleBtn.setTitleColor(.black, for: .normal)
        cancleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancleBtn.addTarget(self, action: #selector(cancleBtnClick), for: .touchUpInside)
        alertView.addSubview(cancleBtn)
        
        /**右边确定按钮*/
        confirmBtn = UIButton(type: .custom)
        confirmBtn.frame = CGRect(x: UIScreen.main.bounds.width - 60 - 5, y: 8, width: 60, height: 28)
        confirmBtn.setTitle("确定", for: .normal)
        confirmBtn.setTitleColor(.black, for: .normal)
        confirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        confirmBtn.addTarget(self, action: #selector(confirmBtnClick), for: .touchUpInside)
        alertView.addSubview(confirmBtn)
        
        /**中间标题*/
        titleLabel = UILabel(frame: CGRect(x: cancleBtn.frame.maxX, y: 8, width: confirmBtn.frame.minX - cancleBtn.frame.maxX, height: 28))
        titleLabel.text = "标题"
        titleLabel.textColor = UIColor(red: 153 / 255.0, green: 153 / 255.0, blue: 153 / 255.0, alpha: 1)
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textAlignment = .center
        alertView.addSubview(titleLabel)
        
        /**间隔线*/
        let lineView = UIView(frame: CGRect(x: 0, y: 43, width: UIScreen.main.bounds.width, height: 1))
        lineView.backgroundColor = UIColor(red: 235 / 255.0, green: 235 / 255.0, blue: 235 / 255.0, alpha: 1)
        alertView.addSubview(lineView)
        
        /**选择器*/
        pickerView = UIPickerView(frame: CGRect(x: 0, y: 44, width: alertView.frame.width, height: 216))
        pickerView.delegate = self
        pickerView.dataSource = self
        alertView.addSubview(pickerView)
    }

    
    // MARK: ------------- UIPickerView dataSource -------------
    /// 设置列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    
    /// 设置每列行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        dataSource.count
    }
    
    
    // MARK: ------------- UIPickerView delegate -------------
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = UILabel()
        label.textAlignment = .center
        label.frame = CGRect(x: 0, y: 0, width: self.pickerView.frame.width, height: 35.0)
        label.text = dataSource[row]
        return label
    }
    
    
    /// pickerView滚动执行的回调方法
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentIndex = row
    }
    
    
    /// 设置行高
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        35.0
    }
    
    
    /// 弹出选择器视图
    func show() {
        IPickerViewMacro.keyWindow().addSubview(self)
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
            self.alertView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 260 - IPickerViewMacro.safeBottomHeight, width: self.alertView.frame.width, height: 260 + IPickerViewMacro.safeBottomHeight)
        }
    }
    
    
    /// 移除选择器视图方法
    func dismiss() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0
            let alertY = self.alertView.frame.size.height + UIScreen.main.bounds.height + IPickerViewMacro.safeBottomHeight
            self.alertView.frame = CGRect(x: 0, y: alertY, width: self.alertView.frame.width, height: 260 + IPickerViewMacro.safeBottomHeight)
        } completion: { (finish) in
            self.removeFromSuperview()
        }
    }
    
    
    /// 点击空白部分移除视图
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch.view != self.alertView {
                self.dismiss()
            }
        }
    }
    
    
    /// 取消按钮的点击事件
    @objc func cancleBtnClick() {
        dismiss()
    }
    
    
    /// 确定按钮的点击事件
    @objc func confirmBtnClick() {
        if dataSource.count > currentIndex && self.resultBlock != nil {
            self.resultBlock!(dataSource[currentIndex] , currentIndex)
        }
        dismiss()
    }
    
    
    /// 显示选择器
    /// - Parameters:
    ///   - title: 选择器标题
    ///   - data: 选择器数据源
    ///   - resultBlock: 选中回调
    class func showPickerView(title: String, data: [String], resultBlock: resultCallBack? = nil) {
        
        let pickView = ICustomDataPickerView()
        pickView.titleLabel.text = title
        pickView.dataSource = data
        pickView.resultBlock = resultBlock
        pickView.show()
    }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
