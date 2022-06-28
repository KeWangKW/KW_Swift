//
//  KWOCViewController.h
//  ShanghaiCard
//
//  Created by 渴望 on 2018/10/31.
//  Copyright © 2018 渴望. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHQDefine.h"
NS_ASSUME_NONNULL_BEGIN

@interface KWOCViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *dataArr;

/**
 HUD显示判断
 不同的页面要根据情况加载HUD 根据修改次状态来判断
 eg: 第一次进入要显示 之后刷新都不显示
 */
@property (nonatomic, assign, getter=isFirstLoadHUD) BOOL firstLoadHUD;

/** 初始化数据 */
- (void)kw_initData;

/** 初始化控件 */
- (void)kw_initUI;

/** 数据请求 */
- (void)kw_request;

/** viewwillappear调用 */
- (void)kw_reloadData;



//- (void)CallPhoneNum:(NSString *)phone;
@end

NS_ASSUME_NONNULL_END
