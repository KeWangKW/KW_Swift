//
//  KWRefreshGroupViewController.swift
//  KW_Swift
//
//  Created by 渴望 on 2021/3/17.
//  Copyright © 2021 guan. All rights reserved.
//

import UIKit


private let defalutPage = "1"

class KWRefreshGroupViewController: KWTableViewGroupController {
    
    public var isAddRefreshHeader: Bool = true {
        didSet {
            self.reloadRefreshUI()
        }
    }
    
    public var isAddRefreshFooter: Bool = false {
        didSet {
            self.reloadRefreshUI()
        }
    }
    
    public var page: String = defalutPage
    
    public var pageCount: String? = defalutPage {
        didSet {
            if page >= pageCount ?? defalutPage {
                self.tableView.kw.footer?.endRefreshingWithNoMoreData()
            } else {
                self.tableView.kw.footer?.resetNoMoreData()
            }
        }
    }
    
    /// 是否执行了下拉刷新操作
    public var isDropDownRefresh: Bool {
        return page == defalutPage
    }
    
    override func kw_setupData() {
        super.kw_setupData()
        
    }
    
    override func kw_setupUI() {
        super.kw_setupUI()
        reloadRefreshUI()
        
        self.tableView.mj_footer?.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    // MARK: - public
    /// 刷新数据 子类中直接调用kw_requestData()即可
    public func kw_refreshData() {
        page = defalutPage
        kw_requestData()
    }
    
    /// 加载数据 子类中直接调用kw_requestData()即可
    public func kw_loadMoreData() {
        page = "\(Int(page)! + 1)"
        kw_requestData()
    }
    
    
    /// 停止刷新加载动画
    public final func kw_stopRefresh() {
        tableView.kw.endRefresh()
    }
    
    
    /// 下拉刷新时删除数据源
    public final func kw_refreshClearData() {
        kw_refreshClearData(data: &dataArr)
    }
    
    /// 下拉刷新时删除数据源
    /// - Parameter data: 数据源
    public final func kw_refreshClearData<T>(data: inout [T])  {
        guard isDropDownRefresh else { return }
        data.removeAll()
    }
    
    /// 更新列表UI
    public final func kw_tableViewReloadData() {
        kw_stopRefresh()
        tableView.reloadData()
        kw_hiddenFooter()
        if page >= pageCount ?? defalutPage {
            self.tableView.kw.footer?.endRefreshingWithNoMoreData()
        } else {
            self.tableView.kw.footer?.resetNoMoreData()
        }
    }
    
    // MARK: - private
    /// 判断是否隐藏footer
    private final func kw_hiddenFooter() {
        guard dataArr.count > 0 else {
            tableView.kw.footer?.isHidden = false
            return
        }
        let items = dataArr.first!
        tableView.kw.footer?.isHidden = items.count == 0
    }
}


extension KWRefreshGroupViewController {
    fileprivate func reloadRefreshUI() {
        
        if !isAddRefreshHeader {
            tableView.kw.header = nil
        } else {
            tableView.kw.refreshHeader { [weak self] in
                self?.kw_refreshData()
            }
        }
        
        if !isAddRefreshFooter {
            tableView.kw.footer = nil
        } else {
            tableView.kw.refreshFooter { [weak self] in
                self?.kw_loadMoreData()
            }
        }
        
        kw_hiddenFooter()
    }
}
