//
//  KWOCTableViewController.m
//  ShanghaiCard
//
//  Created by 渴望 on 2018/11/1.
//  Copyright © 2018 渴望. All rights reserved.
//

#import "KWOCTableViewController.h"
#import "KWOCTableViewCell.h"
#import "UITableView+Ext.h"

@interface KWOCTableViewController ()

@end

@implementation KWOCTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)kw_initData {
    [super kw_initData];
    _style = KWTableViewStylePlain;
}

- (void)kw_initUI {
    [super kw_initUI];
    [self.view addSubview:self.tableView];
    
//    self.tableView.emptyDataSetSource= self;
//    self.tableView.emptyDataSetDelegate= self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArr[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KWOCTableViewCellItem *item = self.dataArr[indexPath.section][indexPath.row];
//    KWOCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:item.cellIdentifier forIndexPath:indexPath];
    KWOCTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:item.cellIdentifier];
    if(cell ==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:item.cellIdentifier];
    }

    cell.item = item;
    
//    if (self.isHideSectionLastCellLine) {
//        cell.hideSeparatorLabel = [self.dataArray[indexPath.section] count] == indexPath.row + 1;
//    }
    //隐藏最后一行cell分割线
    if (cell.hideSeparatorLabel == NO) {
        if (indexPath.row + 1 == [tableView numberOfRowsInSection:indexPath.section]) {
            cell.hideSeparatorLabel = YES;
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return ({
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor Section];
        view;
    });
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return ({
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor Section];
        view;
    });
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    KWOCTableViewCellItem *item = self.dataArr[indexPath.section][indexPath.row];
    if (item.cellHeight > 0) {
        return item.cellHeight;
    }else {
        return [item.cellClass hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
            KWOCTableViewCell *cell = (KWOCTableViewCell *)sourceCell;
            cell.item = item;
        } cache:^NSDictionary *{
            if (!item.cacheKey) {
                return nil;
            }
            return @{kHYBCacheUniqueKey: item.cacheKey};
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

#pragma mark - DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSForegroundColorAttributeName] = [UIColor Assist];
    attributes[NSFontAttributeName] = [UIFont
                                       systemFontOfSize:16];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"暂无数据" attributes:attributes];
    return attributedString;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"zanwushuju"];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return self.tableView.backgroundColor;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -100.f;
}

#pragma mark - DZNEmptyDataSetDelegate
- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView {
    scrollView.contentOffset = CGPointZero;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}


#pragma mark - configureData
- (void)kw_configureData {
    
}

- (void)kw_configureDataWithModel:(KWModel *)model {
    
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        UITableViewStyle style;
        switch (_style)
        {
            case KWTableViewStyleGrouped:
                style = UITableViewStyleGrouped;
                break;
            case KWTableViewStylePlain:
                style = UITableViewStylePlain;
                break;
        }
        CGRect frame = CGRectMake(0, 0, kScreenWidth(), kScreenHeight() - kNavigationStatusHeight());
        _tableView = [[UITableView alloc] initWithFrame:frame style:style];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        @weakify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @strongify(self);
            self->_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        });
        
        [_tableView xhq_registerCell:[KWOCTableViewCell class]];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth(), CGFLOAT_MIN)];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        
    }
    return _tableView;
}

- (NSMutableArray *)sectionArr0 {
    if (!_sectionArr0) {
        _sectionArr0 = [[NSMutableArray alloc]init];
    }
    return _sectionArr0;
}

- (NSMutableArray *)sectionArr1 {
    if (!_sectionArr1) {
        _sectionArr1 = [[NSMutableArray alloc]init];
    }
    return _sectionArr1;
}

- (NSMutableArray *)sectionArr2 {
    if (!_sectionArr2) {
        _sectionArr2 = [[NSMutableArray alloc]init];
    }
    return _sectionArr2;
}

- (NSMutableArray *)sectionArr3 {
    if (!_sectionArr3) {
        _sectionArr3 = [[NSMutableArray alloc]init];
    }
    return _sectionArr3;
}

- (NSMutableArray *)sectionArr4 {
    if (!_sectionArr4) {
        _sectionArr4 = [[NSMutableArray alloc]init];
    }
    return _sectionArr4;
}

- (NSMutableArray *)sectionArr5 {
    if (!_sectionArr5) {
        _sectionArr5 = [[NSMutableArray alloc]init];
    }
    return _sectionArr5;
}

- (NSMutableArray *)sectionArr6 {
    if (!_sectionArr6) {
        _sectionArr6 = [[NSMutableArray alloc]init];
    }
    return _sectionArr6;
}

- (NSMutableArray *)sectionArr7 {
    if (!_sectionArr7) {
        _sectionArr7 = [[NSMutableArray alloc]init];
    }
    return _sectionArr7;
}

//- (NSString *)limitedListNumber {
//    return @"20";
//}






@end
