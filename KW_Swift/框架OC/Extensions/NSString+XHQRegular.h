//
//  NSString+XHQRegular.h
//  Cafu
//
//  Created by 渴望 on 2018/9/3.
//  Copyright © 2018年 diyunkeji. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 正则表达式
 */
@interface NSString (XHQRegular)

/**
 手机号格式检查并提示
 @return YES正确 NO错误
 */
+ (BOOL)xhq_phoneFormatCheck:(NSString *)string;


/**
 密码格式判断 6~20 必须包含数字或者字母
 @return YES正确 NO错误
 */
+ (BOOL)xhq_passFormatCheck:(NSString *)string;


/**
 身份证号格式检查并提示
 @return YES正确 NO错误
 */
+ (BOOL)xhq_idFormatCheck:(NSString *)string;


/**
 邮箱格式检查并提示
 @return YES正确 NO错误
 */
+ (BOOL)xhq_emailFormatCheck:(NSString *)string;


/**
 银行卡号格式检查并提示
 @return YES正确 NO错误
 */
+ (BOOL)xhq_bankCardFormatCheck:(NSString *)string;


/**
 中文姓名格式检查并提示
 @return YES正确 NO错误
 */
+ (BOOL)xhq_cnNameFormatCheck:(NSString *)string;

@end
