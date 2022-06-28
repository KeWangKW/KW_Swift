//
//  UIScrollView+Ext.m
//  ShanghaiCard
//
//  Created by 渴望 on 2018/11/1.
//  Copyright © 2018 渴望. All rights reserved.
//

#import "UIScrollView+Ext.h"
#import "MJRefresh.h"

@implementation UIScrollView (Ext)

@end



@implementation UIScrollView (XHQRefresh)

- (void)xhq_refreshHeaderBlock:(dispatch_block_t)block
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:block];
    header.lastUpdatedTimeLabel.hidden = YES;
    //自定义...
    
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开加载" forState:MJRefreshStatePulling];
    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"加载中..." forState:MJRefreshStateWillRefresh];
    
    header.stateLabel.font = [UIFont systemFontOfSize:13];
    header.stateLabel.textColor = [UIColor blackColor];
    self.mj_header = header;
}

- (void)xhq_refreshFooterBlock:(dispatch_block_t)block
{
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:block];
    //自定义...
    
    [footer setTitle:@" " forState:MJRefreshStateIdle];//上拉加载
    [footer setTitle:@"松开加载" forState:MJRefreshStatePulling];
    [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"加载中..." forState:MJRefreshStateWillRefresh];
    [footer setTitle:@" " forState:MJRefreshStateNoMoreData];//已加载全部
    
    footer.stateLabel.font = [UIFont systemFontOfSize:13];
    footer.stateLabel.textColor = [UIColor blackColor];
    self.mj_footer = footer;
}

- (void)xhq_stopRefresh
{
    if ([self.mj_header isRefreshing]) {
        [self.mj_header endRefreshing];
    }
    if ([self.mj_footer isRefreshing]) {
        [self.mj_footer endRefreshing];
    }
}

@end
