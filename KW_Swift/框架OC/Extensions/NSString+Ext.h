//
//  NSString+Ext.h
//  Excellence
//
//  Created by 渴望 on 2017/7/4.
//  Copyright © 2017年 diyunkeji. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSString+XHQRegular.h"

@interface NSString (Ext)

+ (NSString *)hmac:(NSString *)plaintext withKey:(NSString *)key;
/**
 时间戳转化为时间

 @param formatter 格式
 @return 时间格式 (eg. 2008-08-25)
 */
- (instancetype)xhq_timeIntervalToStringFromatter:(NSString *)formatter;


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 类方法调用


/**
 判断是否存在
 
 @return YES不为空 NO为空
 */
+ (BOOL)xhq_notEmpty:(NSString *)string;

/**
 MD5加密

 @param string 加密前
 @return 加密后
 */
+ (NSString *)xhq_MD5Encryption:(NSString *)string;

/**
 隐藏手机号中间四位
 */
+ (NSString *)xhq_hiddenPhoneNumber:(NSString *)number;

/**
 隐藏身份证号
 */
+ (NSString *)xhq_hiddenIdCardNumber:(NSString *)number;

/**
 隐藏银行卡号
 */
+ (NSString *)xhq_hiddenBankCardNumber:(NSString *)number;

/**
 判断字符串是否为空

 @return YES不为空 NO为空
 */
+ (BOOL)xhq_notNULL:(NSString *)str;


@end





/**
 url解码编码
 */
@interface NSString (XHQURL)

/**
 url解码
 */
+ (NSString*)xhq_URLDecodedString:(NSString*)str;


/**
 url编码
 */
+ (NSString *)xhq_URLEncodedString:(NSString *)str;

@end




@interface NSString (XHQSize)

/**
 计算字符串size
 
 @param font 字体大小
 @param size 限制size
 @return 字符串size
 */
//- (CGSize)xhq_sizeWithFont:(UIFont *)font withSize:(CGSize)size;

@end

