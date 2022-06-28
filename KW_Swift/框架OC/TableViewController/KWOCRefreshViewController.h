//
//  KWOCRefreshViewController.h
//  ShanghaiCard
//
//  Created by 渴望 on 2018/11/1.
//  Copyright © 2018 渴望. All rights reserved.
//

#import "KWOCTableViewController.h"
#import "UIScrollView+Ext.h"
#import "XHQDefine.h"

//FOUNDATION_EXTERN NSString *const kCurrentPageValue;

NS_ASSUME_NONNULL_BEGIN

@interface KWOCRefreshViewController : KWOCTableViewController


/** 当前分页数 */
@property (nonatomic, copy) NSString *page;
/** 总分页数 */
@property (nonatomic, copy) NSString *pageCount;

/** 是否进行了下拉刷新 */
@property (nonatomic, assign, getter=isDropdownRefresh) BOOL dropdownRefresh;

/** 是否添加上拉加载 默认: NO */
@property (nonatomic, assign, getter=isaddRefreshFooter) BOOL addRefreshFooter;

/** 是否添加上拉加载 默认: YES */
@property (nonatomic, assign, getter=isAddRefreshHeader) BOOL addRefreshHeader;


/** 下拉刷新调用 */
- (void)kw_refresh;
/** 上拉加载调用 */
- (void)kw_load;
/** 停止刷新加载动画 */
- (void)kw_stopRefresh;

/** 请求数据结束 下拉刷新要清空数据源 */
- (void)kw_refreshClearData;
- (void)kw_refreshClearWithData:(NSMutableArray *)data;

/** 请求数据结束 刷新页面 重置布局 */
- (void)kw_tableViewReloadData;


/** 根据数据判断是否需要隐藏上拉加载 */
- (void)kw_hiddenFooter:(NSArray *)datas;

@end

NS_ASSUME_NONNULL_END
