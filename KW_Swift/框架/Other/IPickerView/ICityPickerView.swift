//
//  ICityPickerView.swift
//  IPickerView
//
//  Created by Leblanc on 2021/3/2.
//  城市选择  *  本地json文件

import Foundation
import UIKit

/// 声明选中结果闭包
typealias cityResultCallBack = (_ province: String, _ city: String, _ area: String) -> Void
class ICityPickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    /**省市区数据源*/
    lazy var dataSource: [IProvinceModel] = []
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
    var resultBlock: cityResultCallBack?
    /**省index*/
    var provinceIndex: Int = 0
    /**市index*/
    var cityIndex: Int = 0
    /**区index*/
    var areaIndex: Int = 0
    
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
        titleLabel.text = "选择省市区"
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
        
        
        // 加载省市区json文件
        guard let path = Bundle.main.url(forResource: "city", withExtension: "json") else {return}
        do {
            let data: Data = try Data.init(contentsOf: path)
            let array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [Any]
            getModelArray(array)
        } catch let error as Error?  {
            print("读取省市区数据出现错误", error ?? "")
        }
        
    }

    /// 获取省市区模型数组
    func getModelArray(_ array: Array<Any>) {
        
        // 遍历省
        var tempPArray: [IProvinceModel] = []
        
        for (idx, _) in array.enumerated() {
            let pDic: Dictionary = array[idx] as! Dictionary<String, Any>
            let pModel = IProvinceModel()
            pModel.name = pDic["name"] as! String
            pModel.code = pDic["code"] as! String
            pModel.index = idx
            
            // 城市数组
            let cityArray: Array = pDic["cityList"] as! Array<Any>
            var tempCityArray: [ICityModel] = []
            for (ix, _) in cityArray.enumerated() {
                let cDic: Dictionary = cityArray[ix] as! Dictionary<String, Any>
                let cModel = ICityModel()
                cModel.name = cDic["name"] as! String
                cModel.code = cDic["code"] as! String
                cModel.index = ix
                
                // 区域数组
                let areaArray: Array = cDic["areaList"] as! Array<Any>
                var tempAreaArray: [IAreaModel] = []
                for (i, _) in areaArray.enumerated() {
                    let aDic: Dictionary = areaArray[i] as! Dictionary<String, Any>
                    let aModel = IAreaModel()
                    aModel.name = aDic["name"] as! String
                    aModel.code = aDic["code"] as! String
                    aModel.index = i
                    tempAreaArray.append(aModel)
                }
                cModel.arealist = tempAreaArray
                tempCityArray.append(cModel)
            }
            pModel.citylist = tempCityArray
            tempPArray.append(pModel)
        }
        
        dataSource = tempPArray
        // 刷新pickerView
        pickerView.reloadAllComponents()
        
    }
    
    
    // MARK: ------------- UIPickerView dataSource -------------
    /// 设置列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        3
    }
    
    
    /// 设置每列行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 1 {
            return dataSource[provinceIndex].citylist.count
        } else if component == 2 {
            if dataSource[provinceIndex].citylist.count > 0 {
                if dataSource[provinceIndex].citylist[cityIndex].arealist.count > 0 {
                    return dataSource[provinceIndex].citylist[cityIndex].arealist.count
                }
                return 0
            }
            return 0
        }
        return dataSource.count
    }
    
    
    // MARK: ------------- UIPickerView delegate -------------
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = UILabel()
        label.textAlignment = .center
        label.frame = CGRect(x: 0, y: 0, width: self.pickerView.frame.width, height: 35.0)
        
        if component == 1 {
            label.text = dataSource[provinceIndex].citylist[row].name
        } else if component == 2 {
            label.text = dataSource[provinceIndex].citylist[cityIndex].arealist[row].name
        } else {
            label.text = dataSource[row].name
        }
        return label
    }
    
    
    /// pickerView滚动执行的回调方法
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 1 {
            cityIndex = row
            areaIndex = 0
            pickerView.selectRow(0, inComponent: 2, animated: true)
        } else if component == 2 {
            areaIndex = row
        } else {
            provinceIndex = row
            cityIndex = 0
            areaIndex = 0
            pickerView.selectRow(0, inComponent: 1, animated: true)
            pickerView.selectRow(0, inComponent: 2, animated: true)
        }
        pickerView.reloadAllComponents()
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
        if self.resultBlock != nil {
            // 省
            let pStr = dataSource[provinceIndex].name
            // 城市、区
            var cStr = ""
            var aStr = ""
            if dataSource[provinceIndex].citylist.count > 0 {
                cStr = dataSource[provinceIndex].citylist[cityIndex].name
                if dataSource[provinceIndex].citylist[cityIndex].arealist.count > 0 {
                    aStr = dataSource[provinceIndex].citylist[cityIndex].arealist[areaIndex].name
                }
            }
            self.resultBlock!(pStr, cStr, aStr)
        }
        dismiss()
    }
    
    
    /// 显示选择器
    /// - Parameters:
    ///   - resultBlock: 选中回调
    class func showPickerView(resultBlock: cityResultCallBack? = nil) {
        
        let pickView = ICityPickerView()
        pickView.resultBlock = resultBlock
        pickView.show()
    }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: ------------- 省model -------------
class IProvinceModel: NSObject {
    
    /**
     省code
     */
    var code: String = ""
    /**
     省名称
     */
    var name: String = ""
    /**
     省包含的城市数组
     */
    var citylist: [ICityModel]!
    /**
     下标
     */
    var index: Int = 0
    
}


// MARK: ------------- 城市model -------------
class ICityModel: NSObject {
    
    /**
     城市code
     */
    var code: String = ""
    /**
     城市名称
     */
    var name: String = ""
    /**
     城市包含的地区数组
     */
    var arealist: [IAreaModel]!
    /**
     下标
     */
    var index: Int = 0
    
}

// MARK: ------------- 区model -------------
class IAreaModel: NSObject {
    
    /**
     区code
     */
    var code: String = ""
    /**
     区的名称
     */
    var name: String = ""
    /**
     下标
     */
    var index: Int = 0
    
}
