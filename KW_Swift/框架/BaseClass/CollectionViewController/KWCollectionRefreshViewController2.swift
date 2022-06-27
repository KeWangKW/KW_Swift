//
//  KWCollectionRefreshViewController2.swift
//  Whatever
//
//  Created by 渴望 on 2020/6/2.
//  Copyright © 2020 渴望. All rights reserved.
//

import UIKit

private let defalutPage = "1"

class KWCollectionRefreshViewController2: KWCollectionViewController2, KWRefreshProtocol {
    
    var isRefreshData:Bool = false
    var isLoadMoreData:Bool = false
    
    
    
    var isAddRefreshHeader: Bool = true {
        didSet {
            reloadRefreshUI()
        }
    }
    
    var isAddRefreshFooter: Bool = false {
        didSet {
            reloadRefreshUI()
        }
    }
    
    var page: String = defalutPage
    
    var pageCount: String? = defalutPage {
        didSet {
            if Int(page) ?? 1 >= Int(pageCount!) ?? 1 {
                self.collectionView.kw.footer?.endRefreshingWithNoMoreData()
            } else {
                self.collectionView.kw.footer?.resetNoMoreData()
            }
        }
    }
    
    var isDropDownRefresh: Bool {
        return page == defalutPage
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func kw_setupData() {
        super.kw_setupData()
        
    }
    
    override func kw_configureData() {
        
    }
    
    override func kw_setupUI() {
        super.kw_setupUI()
        reloadRefreshUI()
        
        self.collectionView.mj_footer?.isHidden = true
    }
    
    func kw_refreshData() {
        self.isRefreshData = true
        page = defalutPage
        kw_requestData()
    }
    
    func kw_loadMoreData() {
        self.isLoadMoreData = true
        page = "\(Int(page)! + 1)"
        kw_requestData()
    }
    
    func kw_stopRefresh() {
        collectionView.kw.endRefresh()
    }
    
    func kw_refreshClearData() {
        kw_refreshClearData(data: &dataArr)
    }
    
    func kw_refreshClearData<T>(data: inout [T])  {
        guard isDropDownRefresh else { return }
        data.removeAll()
    }
    
    func kw_viewReloadData() {
        self.isRefreshData = false
        self.isLoadMoreData = false
        kw_stopRefresh()
        collectionView.reloadData()
        kw_hiddenFooter()
//        if page >= pageCount ?? defalutPage {
        if Int(page) ?? 1 >= Int(pageCount!) ?? 1 {
            self.collectionView.kw.footer?.endRefreshingWithNoMoreData()
        } else {
            self.collectionView.kw.footer?.resetNoMoreData()
        }
    }
    
    
    // MARK: - private
    /// 判断是否隐藏footer
    private final func kw_hiddenFooter() {
        guard dataArr.count > 0 else {
            collectionView.kw.footer?.isHidden = false
            return
        }
        let items = dataArr.first!
        collectionView.kw.footer?.isHidden = items.count == 0
    }
}


extension KWCollectionRefreshViewController2 {
    fileprivate func reloadRefreshUI() {
        
        if !isAddRefreshHeader {
            collectionView.kw.header = nil
        } else {
            collectionView.kw.refreshHeader { [weak self] in
                self?.kw_refreshData()
            }
        }
        
        if !isAddRefreshFooter {
            collectionView.kw.footer = nil
        } else {
            collectionView.kw.refreshFooter { [weak self] in
                self?.kw_loadMoreData()
            }
        }
    }
}


