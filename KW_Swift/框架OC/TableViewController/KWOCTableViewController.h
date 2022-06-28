//
//  KWOCTableViewController.h
//  ShanghaiCard
//
//  Created by 渴望 on 2018/11/1.
//  Copyright © 2018 渴望. All rights reserved.
//

#import "KWOCViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "KW_Swift-Swift.h"
#import "UITableView+HYBCacheHeight.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"
#import "XHQDefine.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, KWTableViewStyle) {
    KWTableViewStylePlain = 0,
    KWTableViewStyleGrouped
};

@interface KWOCTableViewController : KWOCViewController<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) KWTableViewStyle style;

/**
 隐藏section最后一个cell的底部线
 */
//@property (nonatomic, assign, getter=isHideSectionLastCellLine) BOOL hideSectionLastCellLine;

@property (nonatomic, strong) NSMutableArray *sectionArr0;
@property (nonatomic, strong) NSMutableArray *sectionArr1;
@property (nonatomic, strong) NSMutableArray *sectionArr2;
@property (nonatomic, strong) NSMutableArray *sectionArr3;
@property (nonatomic, strong) NSMutableArray *sectionArr4;
@property (nonatomic, strong) NSMutableArray *sectionArr5;
@property (nonatomic, strong) NSMutableArray *sectionArr6;
@property (nonatomic, strong) NSMutableArray *sectionArr7;


///**
// 每页列表限制条数
// */
//@property (nonatomic, copy, readonly) NSString *limitedListNumber;


/** 初始化数据 */
- (void)kw_configureData;
/** 初始化数据 */
- (void)kw_configureDataWithModel:(KWModel *)model;

@end

NS_ASSUME_NONNULL_END
