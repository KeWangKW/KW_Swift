//
//  BISWDDetailVC.swift
//  KW_Swift
//
//  Created by 渴望 on 2021/4/27.
//  Copyright © 2021 guan. All rights reserved.
//

import UIKit

class BISWDDetailVC: KWViewController {
    var vcType:String = "0" //0积分商城提现 1共享云库提现 2我的资产提现
    var isBIShopWDUse:Bool = false
    var isBIShopWDUseId:String = ""
    var model: SharePayInfoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "详情"
        // Do any additional setup after loading the view.
    }


    override func kw_setupData() {
        super.kw_setupData()
        
    }
    
    override func kw_setupUI() {
        super.kw_setupUI()
        
    }
    
    override func kw_requestData() {
        super.kw_requestData()
        
        if isBIShopWDUse {
            if self.vcType == "1" {
                requestDetail3()
            }else if self.vcType == "100" {
                requestDetail2()
            }else{
                requestDetail4()
            }
        }else{
            requestDetail()
        }
    }

    
    @IBOutlet weak var imgv: UIImageView!
    @IBOutlet weak var priceLab: UILabel!
    @IBOutlet weak var statusLab: UILabel!
    
    @IBOutlet weak var wdTypeLab: UILabel!
    @IBOutlet weak var wdTypeLLLab: UILabel!
    @IBOutlet weak var wdType: UILabel!
    @IBOutlet weak var accountLab: UILabel!
    @IBOutlet weak var poundageLab: UILabel!
    @IBOutlet weak var timeLab: UILabel!
    @IBOutlet weak var orderNumLab: UILabel!
    
    
    @IBAction func selectCopyBtn(_ sender: Any) {
        let pas = UIPasteboard.general
//        pas.string = self.model?.withdrawal?.order_no
        pas.string = self.orderNumLab.text
        self.kw.showTextHUD("已复制到剪切板")
    }
}

extension BISWDDetailVC {
    //MARK: 详情
    func requestDetail() {
        let params = ["id":model?.id]
        PublicCloudReq.request(.getShareTransactionDetail(params: params as [String : Any])) { (result) in
            if case let .success(obj) = result {
                if obj.success {
                    guard let dic = obj.info as? NSDictionary else {
                        return
                    }
                    self.model = SharePayInfoModel.toModel(dic)
                    
                    if self.model?.withdrawal?.collection_type == "1" {
                        self.imgv.image = UIImage(named: "支付宝")
                        self.wdTypeLab.text = "支付宝"
                    }else{
                        self.imgv.image = UIImage(named: "yhk")
                        self.wdTypeLab.text = "银行卡"
                    }
                    self.priceLab.text = self.model?.total_amount
                    self.statusLab.text = self.model?.withdrawal?.statusText
                    
                    self.accountLab.text = self.model?.withdrawal?.card
                    self.poundageLab.text = self.model?.withdrawal?.service_charge_amount
                    self.timeLab.text = self.model?.create_time
                    self.orderNumLab.text = self.model?.withdrawal?.order_no
                    
                    
                    
                }else{
                    self.kw.showErrorHUD(text: obj.message)
                }
            }
        }
    }
    
    
    func requestDetail2() {
        let params = ["id": isBIShopWDUseId]
        BIntegerShopReq.request(.IntegralMallGetReservesWithdrawalDetail(params:params)) { (result) in

            if case let .success(obj) = result {
                if obj.success {
                    
                    let mo = BISWDDetailModel.toModel(obj.info as? NSDictionary) ?? BISWDDetailModel()
                    self.imgv.kf.setImage(with: URL(string: mo.logo))
                    self.priceLab.text = mo.amount
                    // 1审核中 2审核通过 3审核拒绝 4通过
                    if mo.status == "1" {
                        self.statusLab.text = "审核中"
                    }else if mo.status == "2" {
                        self.statusLab.text = "审核通过"
                    }else if mo.status == "3" {
                        self.statusLab.text = "审核拒绝"
                    }else{
                        self.statusLab.text = "通过"
                    }
                    
                    self.wdTypeLab.text = mo.amount
                    self.accountLab.text = mo.card
                    self.poundageLab.text = mo.service_charge_amount
                    self.timeLab.text = mo.add_time
                    self.orderNumLab.text = mo.order_no
                    
                    if self.vcType == "100" {
                        self.wdTypeLLLab.text = "退回方式"
                        self.wdType.text = "退款"
                    }
                    
                }else{
                    self.kw.showErrorHUD(text: obj.message)
                }
            }
        }
    }
    
    func requestDetail3() {
        let params = ["id": isBIShopWDUseId]
        PublicCloudReq.request(.ShareGetShareWithdrawalDetail(params:params)) { (result) in

            if case let .success(obj) = result {
                if obj.success {
                    
                    let mo = BISWDDetailModel.toModel(obj.info as? NSDictionary) ?? BISWDDetailModel()
                    self.imgv.kf.setImage(with: URL(string: mo.logo))
                    self.priceLab.text = mo.amount
                    // 1审核中 2审核通过 3审核拒绝 4通过
                    if mo.status == "1" {
                        self.statusLab.text = "审核中"
                    }else if mo.status == "2" {
                        self.statusLab.text = "审核通过"
                    }else if mo.status == "3" {
                        self.statusLab.text = "审核拒绝"
                    }else{
                        self.statusLab.text = "通过"
                    }
                    
                    self.wdTypeLab.text = mo.amount
                    self.accountLab.text = mo.card
                    self.poundageLab.text = mo.service_charge_amount
                    self.timeLab.text = mo.add_time
                    self.orderNumLab.text = mo.order_no
                }else{
                    self.kw.showErrorHUD(text: obj.message)
                }
            }
        }
    }
    
    
    func requestDetail4() {
        let params = ["id": isBIShopWDUseId]
        BIntegerShopReq.request(.financeGgetWithdrawDetail(params:params)) {
            (result) in
            if case let .success(obj) = result {
                if obj.success {
                    
                    let mo = BISWDDetailModel.toModel(obj.info as? NSDictionary) ?? BISWDDetailModel()
                    self.imgv.kf.setImage(with: URL(string: mo.logo))
                    self.priceLab.text = mo.amount
                    // 1审核中 2审核通过 3审核拒绝 4通过
                    if mo.status == "1" {
                        self.statusLab.text = "审核中"
                    }else if mo.status == "2" {
                        self.statusLab.text = "审核通过"
                    }else if mo.status == "3" {
                        self.statusLab.text = "审核拒绝"
                    }else{
                        self.statusLab.text = "通过"
                    }
                    
                    self.wdTypeLab.text = mo.amount
                    self.accountLab.text = mo.card
                    self.poundageLab.text = mo.service_charge_amount
                    self.timeLab.text = mo.add_time
                    self.orderNumLab.text = mo.order_no
                }else{
                    self.kw.showErrorHUD(text: obj.message)
                }
            }
        }
    }
    
    
}
