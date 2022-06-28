//
//  UITableView+Ext.m
//  Excellence
//
//  Created by 渴望 on 2017/6/16.
//  Copyright © 2017年 diyunkeji. All rights reserved.
//

#import "UITableView+Ext.h"

@implementation UITableView (Ext)

- (void)xhq_registerXibCell:(Class _Nullable )cellClass {
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(cellClass) bundle:nil] forCellReuseIdentifier:NSStringFromClass(cellClass)];
}

- (void)xhq_registerCell:(Class _Nullable )cellClass {
    [self registerClass:cellClass forCellReuseIdentifier:NSStringFromClass(cellClass)];
}

- (void)xhq_registerView:(Class _Nullable )viewClass {
    [self registerClass:viewClass forHeaderFooterViewReuseIdentifier:NSStringFromClass(viewClass)];
}

- (UITableViewCell *)xhq_dequeueCell:(Class)cellClass indexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableCellWithIdentifier:NSStringFromClass([cellClass class]) forIndexPath:indexPath];
}

- (UITableViewHeaderFooterView *)xhq_dequeueView:(Class)viewClass {
    return [self dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(viewClass)];
}

@end
