//
//  KWOCTableViewCell.h
//  ShanghaiCard
//
//  Created by 渴望 on 2018/11/1.
//  Copyright © 2018 渴望. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KW_Swift-Swift.h"
#import "NSString+Ext.h"
#import "UITableView+HYBCacheHeight.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"

NS_ASSUME_NONNULL_BEGIN

static const CGFloat DYCellSideMarge = 15.f;

@class KWModel;
@interface KWOCTableViewCellItem : NSObject

/** 标识 */
@property (nonatomic, strong) NSString *cellIdentifier;
/** 数据源 */
@property (nonatomic, strong) KWModel *cellModel;
/** 高度 */
@property (nonatomic, assign) CGFloat cellHeight;
/** 缓存标识 */
@property (nonatomic, copy) NSString *cacheKey;

/** 当前class */
@property (nonatomic, weak, readonly) Class cellClass;

/** 标题 */
@property (nonatomic, strong) NSString *title;
/** 图片 */
@property (nonatomic, strong) NSString *imageName;

/** 显示指示器 */
@property (nonatomic, assign, getter=isShowIndicator) BOOL showIndicator;

/** 自定义底线 */
@property (nonatomic, assign, getter=isHideSeparatorLabel) BOOL hideSeparatorLabel;

/** 初始化 */
+ (instancetype)item;

@end


@interface KWOCTableViewCell : UITableViewCell

/** 自定义底线 */
@property (nonatomic, assign) BOOL hideSeparatorLabel;

/** 底线的所有间距 */
@property (nonatomic, assign) CGFloat sideMargin;

/** 赋值item */
@property (nonatomic, strong) KWOCTableViewCellItem *item;


/** 初始化UI */
- (void)kw_initUI;

/** 取消选中效果 */
- (void)dy_noneSelectionStyle;

@end

NS_ASSUME_NONNULL_END
