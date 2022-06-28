//
//  Refresh.swift
//  InheritTableViewController
//
//  Created by 渴望 on 2020/5/19.
//  Copyright © 2020 渴望. All rights reserved.
//

import UIKit

#if canImport(MJRefresh)
import MJRefresh

public extension KWSwiftWrapper where Base: UIScrollView {
    var header: MJRefreshHeader? {
        get { return base.mj_header }
        set { base.mj_header = newValue }
    }
    var footer: MJRefreshFooter? {
        get { return base.mj_footer }
        set { base.mj_footer = newValue}
    }
    
    func refreshHeader(_ closure: @escaping () -> Void) {
        base.mj_header = RefreshHeader(refreshingBlock: closure)
    }
    
    func refreshFooter(_ closure: @escaping () -> Void) {
        base.mj_footer = RefreshFooter(refreshingBlock: closure)
    }
    
    func endRefresh() {
        if let head = header, head.isRefreshing {
            head.endRefreshing()
        }
        if let foot = footer, foot.isRefreshing {
            foot.endRefreshing()
        }
    }
}


class RefreshHeader: MJRefreshNormalHeader {
    override func prepare() {
        super.prepare()
        
        setTitle("下拉刷新", for: .idle)
        setTitle("松开刷新", for: .pulling)
        setTitle("刷新数据中...", for: .refreshing)
        setTitle("刷新数据中...", for: .willRefresh)
        
        lastUpdatedTimeLabel?.isHidden = true
        stateLabel?.font = .systemFont(ofSize: 13)
        
        stateLabel?.textColor = .custom(.content)
        loadingView?.color = .custom(.content)

        if #available(iOS 13.0, *) {
            loadingView?.style = .medium
        }
    }
}

///上拉自动加载
class RefreshFooter: MJRefreshAutoNormalFooter {
    override func prepare() {
        super.prepare()

        setTitle("", for: .idle) //点击或上拉加载
        setTitle("松开加载", for: .pulling)
        setTitle("数据加载中...", for: .refreshing)
        setTitle("数据加载中...", for: .willRefresh)
        setTitle("", for: .noMoreData) //已加载全部 已经到底了

        stateLabel?.font = .systemFont(ofSize: 13)
        stateLabel?.textColor = .custom(.content)
        loadingView?.color = .custom(.content)

        if #available(iOS 13.0, *) {
            loadingView?.style = .medium
        }
    }
}

///松手后加载
class RefreshFooter2: MJRefreshBackNormalFooter {
    override func prepare() {
        super.prepare()

        setTitle("上拉可以加载更多", for: .idle) //
        setTitle("松开立即加载更多", for: .pulling)
        setTitle("正在加载更多数据...", for: .refreshing)
        setTitle("正在加载更多数据...", for: .willRefresh)
        setTitle("已经到底了", for: .noMoreData) //已加载全部 已经到底了

        stateLabel?.font = .systemFont(ofSize: 13)
        stateLabel?.textColor = .custom(.content)
        loadingView?.color = .custom(.content)

        if #available(iOS 13.0, *) {
            loadingView?.style = .medium
        }
    }
}


#endif
