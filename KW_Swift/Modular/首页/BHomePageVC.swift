//
//  ZProjectManagerVC.swift
//  KW_Swift
//
//  Created by 渴望 on 2020/12/8.
//  Copyright © 2020 渴望. All rights reserved.
//

import UIKit

class BHomePageVC: KWCollectionRefreshViewController  {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nav_color_clear()
        self.fd_prefersNavigationBarHidden = true
        
    }
    
    override func kw_setupData() {
        super.kw_setupData()
        
        kw.emptyDataSetTitle = "233333"
        kw.emptyDataSetImage = UIImage()
        
        isAddRefreshHeader = true
        isAddRefreshFooter = true
    }
    
    override func kw_setupUI() {
        super.kw_setupUI()
        collectionView.kw.registerXib2(cell: BHPPDListCell.self)
    }
    
    override func kw_requestData() {
        super.kw_requestData()
        
        /*
        let params = ["page": self.page,
                      "limit": "10"] as [String : Any]
        BHomeReq.request(.getHomeData(params: params)) { (result) in
            if case let .success(obj) = result {
                if obj.success {
                    if let _ = UIViewController.kw.currentController() as? BHomePageVC { }else{ return }
                    
                    //let moArr:[BPDDDModel] = BPDDDModel.toModels(obj.info as? NSArray) ?? []
                    let mo = BPDModel.toModel(obj.info as? NSDictionary) ?? BPDModel()
                    self.pageCount = mo.pageCount
                    
                    self.reloadCell(mo)
                    
                }else{
                    self.collectionView.mj_header?.endRefreshing()
                    self.kw.showErrorHUD(text: obj.message)
                }
            }
        }*/
        
        
        self.pageCount = "1000"
        let moo1 = BPDDDModel()
        moo1.name = "1"
        
        let moo2 = BPDDDModel()
        moo2.name = "2"
        
        let moo3 = BPDDDModel()
        moo3.name = "3"
        
        let mo = BPDModel()
        mo.data = [moo1,moo2,moo3]
        self.reloadCell(mo)
    }
    
    
    func reloadCell(_ mo:BPDModel) {
        kw_refreshClearData(data: &self.dataArr)
        kw_refreshClearData(data: &self.section0Arr)
        
        for moo in mo.data {
            let item = BHPPDListCellItem()
            item.cellModel = moo
            section0Arr.append(item)
        }
        dataArr.append(section0Arr)
        kw_viewReloadData()
    }
    
}


//MARK: CollectionView代理
extension BHomePageVC{
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //section 上下左右边距
        return UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8  //列间距
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7  //行间距
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}



