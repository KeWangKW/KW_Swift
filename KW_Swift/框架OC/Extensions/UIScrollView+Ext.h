//
//  UIScrollView+Ext.h
//  ShanghaiCard
//
//  Created by 渴望 on 2018/11/1.
//  Copyright © 2018 渴望. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (Ext)

@end

NS_ASSUME_NONNULL_END


NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (XHQRefresh)

- (void)xhq_refreshHeaderBlock:(dispatch_block_t)block;

- (void)xhq_refreshFooterBlock:(dispatch_block_t)block;

- (void)xhq_stopRefresh;

@end

NS_ASSUME_NONNULL_END
