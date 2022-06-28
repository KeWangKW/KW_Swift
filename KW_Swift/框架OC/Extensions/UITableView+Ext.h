//
//  UITableView+Ext.h
//  Excellence
//
//  Created by 渴望 on 2017/6/16.
//  Copyright © 2017年 diyunkeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Ext)
- (void)xhq_registerXibCell:(Class _Nullable )cellClass;
- (void)xhq_registerCell:(Class _Nullable )cellClass;

- (void)xhq_registerView:(Class _Nullable )viewClass;

- (nullable __kindof UITableViewCell *)xhq_dequeueCell:(Class _Nullable )cellClass indexPath:(NSIndexPath *_Nullable)indexPath;

- (nullable __kindof UITableViewHeaderFooterView *)xhq_dequeueView:(Class _Nullable )viewClass;

@end
