//
//  kwRefreshProtocol.swift
//  Whatever
//
//  Created by 渴望 on 2020/6/2.
//  Copyright © 2020 渴望. All rights reserved.
//

import Foundation

protocol KWRefreshProtocol: class {
    
    /// 添加头部刷新
    var isAddRefreshHeader: Bool { get set }
    /// 添加尾部刷新
    var isAddRefreshFooter: Bool { get set }
    /// 页码
    var page: String { get set }
    /// 总页数
    var pageCount: String? { get set }
    
    /// 是否进行了下拉刷新
    var isDropDownRefresh: Bool { get }
    
    /// 下拉刷新
    func kw_refreshData()
    /// 加载更多
    func kw_loadMoreData()
    
    /// 停止刷新
    func kw_stopRefresh()
    
    /// 刷新当前列表
    func kw_viewReloadData()
}



extension KWRefreshProtocol where Self: KWCollectionRefreshViewController {
    
}

extension KWRefreshProtocol where Self: KWRefreshViewController {
    
}
