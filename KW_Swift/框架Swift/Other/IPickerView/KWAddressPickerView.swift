//
//  KWAddressPickerView.swift
//  IPickerView
//
//  Created by Leblanc on 2021/3/2.
//  省市区地址选择  *  接口数据

import Foundation
import UIKit

/// 声明选中结果闭包
typealias KWAddressResultCallBack = (_ province: String, _ city: String, _ area: String, _ provinceCode: String, _ cityCode: String, _ areaCode: String) -> Void
class KWAddressPickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    /**省市区数据源*/
    lazy var dataSource: [KW_ProvinceModel] = []
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
    var resultBlock: KWAddressResultCallBack?
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
//        guard let path = Bundle.main.url(forResource: "city", withExtension: "json") else {return}
//        do {
//            let data: Data = try Data.init(contentsOf: path)
//            let array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [Any]
//            getModelArray(array)
//        } catch let error as Error?  {
//            print("读取省市区数据出现错误", error ?? "")
//        }
        pickerView.reloadAllComponents()
    }

//    /// 获取省市区模型数组
//    func getModelArray(_ array: Array<Any>) {
//
//        // 遍历省
//        var tempPArray: [KW_ProvinceModel] = []
//
//        for (idx, _) in array.enumerated() {
//            let pDic: Dictionary = array[idx] as! Dictionary<String, Any>
//            let pModel = KW_ProvinceModel()
//            pModel.title = pDic["title"] as! String
//            pModel.value = pDic["value"] as! String
//            pModel.index = idx
//
//            // 城市数组
//            let cityArray: Array = pDic["cityList"] as! Array<Any>
//            var tempCityArray: [KW_CityModel] = []
//            for (ix, _) in cityArray.enumerated() {
//                let cDic: Dictionary = cityArray[ix] as! Dictionary<String, Any>
//                let cModel = KW_CityModel()
//                cModel.title = cDic["title"] as! String
//                cModel.value = cDic["value"] as! String
//                cModel.index = ix
//
//                // 区域数组
//                let areaArray: Array = cDic["areaList"] as! Array<Any>
//                var tempAreaArray: [KW_AreaModel] = []
//                for (i, _) in areaArray.enumerated() {
//                    let aDic: Dictionary = areaArray[i] as! Dictionary<String, Any>
//                    let aModel = KW_AreaModel()
//                    aModel.title = aDic["title"] as! String
//                    aModel.value = aDic["value"] as! String
//                    aModel.index = i
//                    tempAreaArray.append(aModel)
//                }
//                cModel.cities = tempAreaArray
//                tempCityArray.append(cModel)
//            }
//            pModel.cities = tempCityArray
//            tempPArray.append(pModel)
//        }
//
//        dataSource = tempPArray
//        // 刷新pickerView
//        pickerView.reloadAllComponents()
//
//    }
    
    
    var pickNum:Int = 3
    // MARK: UIPickerView dataSource
    /// 设置列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        pickNum
    }
    
    
    /// 设置每列行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 1 {
            return dataSource[provinceIndex].cities.count
        } else if component == 2 {
            if dataSource[provinceIndex].cities.count > 0 {
                if dataSource[provinceIndex].cities[cityIndex].cities.count > 0 {
                    return dataSource[provinceIndex].cities[cityIndex].cities.count
                }
                return 0
            }
            return 0
        }
        return dataSource.count
    }
    
    
    // MARK: UIPickerView delegate
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = UILabel()
        label.textAlignment = .center
        label.frame = CGRect(x: 0, y: 0, width: self.pickerView.frame.width, height: 35.0)
        
        if component == 1 {
            label.text = dataSource[provinceIndex].cities[row].title
        } else if component == 2 {
            label.text = dataSource[provinceIndex].cities[cityIndex].cities[row].title
        } else {
            label.text = dataSource[row].title
        }
        return label
    }
    
    
    /// pickerView滚动执行的回调方法
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            //选择省
            provinceIndex = row
            cityIndex = 0
            pickerView.selectRow(0, inComponent: 1, animated: true)
            
            if pickNum == 3 {
                areaIndex = 0
                pickerView.selectRow(0, inComponent: 2, animated: true)
            }
        }else if component == 1 {
            //选择市
            cityIndex = row
            areaIndex = 0
            
            if pickNum == 3 {
                pickerView.selectRow(0, inComponent: 2, animated: true)
            }
        } else if component == 2 {
            //选择区
            areaIndex = row
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
            let pStr = dataSource[provinceIndex].title
            let pCode = dataSource[provinceIndex].value
            // 城市、区
            var cStr = ""
            var cCode = ""
            var aStr = ""
            var aCode = ""
            if dataSource[provinceIndex].cities.count > 0 {
                cStr = dataSource[provinceIndex].cities[cityIndex].title
                cCode = dataSource[provinceIndex].cities[cityIndex].value
                if dataSource[provinceIndex].cities[cityIndex].cities.count > 0 {
                    aStr = dataSource[provinceIndex].cities[cityIndex].cities[areaIndex].title
                    aCode = dataSource[provinceIndex].cities[cityIndex].cities[areaIndex].value
                }
            }
            self.resultBlock!(pStr, cStr, aStr ,pCode ,cCode ,aCode)
        }
        dismiss()
    }
    
    
    /// 显示选择器
    /// - Parameters:
    ///   - resultBlock: 选中回调
    class func showPickerView( addressData:[KW_ProvinceModel] , pickNum:Int , resultBlock: KWAddressResultCallBack? = nil) {
        
        let pickView = KWAddressPickerView()
        pickView.dataSource = addressData
        pickView.pickNum = pickNum
        pickView.resultBlock = resultBlock
        pickView.show()
    }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: 省model
class KW_ProvinceModel: KWModel {
    var value: String = ""
    var title: String = ""
    var cities: [KW_CityModel] = []
    var index: Int = 0
}
// MARK: 市model
class KW_CityModel: KWModel {
    var value: String = ""
    var title: String = ""
    var cities: [KW_AreaModel] = []
    var index: Int = 0
}
// MARK: 区model
class KW_AreaModel: KWModel {
    var value: String = ""
    var title: String = ""
    var index: Int = 0
}
// MARK: 街道model
//class KW_StreetModel: KWModel {
//    var code: String = ""
//    var name: String = ""
//    var index: Int = 0
//}
