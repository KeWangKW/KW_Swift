//
//  KWOCRefreshViewController.m
//  ShanghaiCard
//
//  Created by 渴望 on 2018/11/1.
//  Copyright © 2018 渴望. All rights reserved.
//

#import "KWOCRefreshViewController.h"
#import "MJRefresh.h"

@interface KWOCRefreshViewController ()

@end

//NSString *const kCurrentPageValue = @"1";

@implementation KWOCRefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)kw_initData {
    [super kw_initData];
    self.page = @"1";
    self.addRefreshFooter = NO;
    self.addRefreshHeader = YES;
    self.dropdownRefresh = YES;
}

- (void)kw_initUI {
    [super kw_initUI];
    
    @weakify(self);
    if (self.isAddRefreshHeader) {
        [self.tableView xhq_refreshHeaderBlock:^{
            @strongify(self);
            [self kw_refresh];
        }];
    }
    if (self.isaddRefreshFooter) {
        [self.tableView xhq_refreshFooterBlock:^{
            @strongify(self);
            [self kw_load];
        }];
        [self kw_hiddenFooter];
    }
}

- (void)kw_refresh {
    self.page = @"1";
    self.dropdownRefresh = YES;
    [self kw_request];
}

- (void)kw_load {
    self.page = [NSString stringWithFormat:@"%ld", self.page.integerValue + 1];
    [self kw_request];
}

- (void)kw_stopRefresh {
//    [self.tableView.mj_header endRefreshing];
//    [self.tableView.mj_footer endRefreshing];
    [self.tableView xhq_stopRefresh];
}

- (void)kw_tableViewReloadData {
    [self kw_stopRefresh];
    [self.tableView reloadData];
    [self dy_footerWithNoMoreData];
    [self kw_hiddenFooter];
    if (self.isDropdownRefresh) {
        self.dropdownRefresh = !self.isDropdownRefresh;
    }
}

#pragma mark - 修改footer显示状态
- (void)dy_footerWithNoMoreData {
    if (!self.isaddRefreshFooter) {
        return;
    }
    if (_page.integerValue >= _pageCount.integerValue) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        
    }else {
        [self.tableView.mj_footer resetNoMoreData];
        
    }
}

#pragma mark - 隐藏上拉加载
- (void)kw_hiddenFooter {
    [self kw_hiddenFooter:self.dataArr];
}

- (void)kw_hiddenFooter:(NSArray *)datas {
    BOOL hidden = NO;
    if (datas.count > 0) {
        id firstObj = datas.firstObject;
        if ([firstObj isKindOfClass:[NSMutableArray class]]) {
            NSMutableArray *array = (NSMutableArray *)firstObj;
            hidden = array.count == 0;
        }
    }else {
        hidden = YES;
    }
    [self.tableView.mj_footer setHidden:hidden];
}

#pragma mark - 清除数据源
- (void)kw_refreshClearData {
    [self kw_refreshClearWithData:self.dataArr];
}

- (void)kw_refreshClearWithData:(NSMutableArray *)data {
    if (self.isDropdownRefresh) {
        NSMutableArray *temp = data ? : self.dataArr;
        [temp removeAllObjects];
        self.dropdownRefresh = !self.isDropdownRefresh;
    }
}

@end
