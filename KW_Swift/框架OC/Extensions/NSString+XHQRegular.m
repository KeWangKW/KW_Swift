//
//  NSString+XHQRegular.m
//  Cafu
//
//  Created by 渴望 on 2018/9/3.
//  Copyright © 2018年 diyunkeji. All rights reserved.
//

#import "NSString+XHQRegular.h"

@implementation NSString (XHQRegular)

//手机号
+ (BOOL)xhq_phoneFormatCheck:(NSString *)string {
    
    NSString *regex = @"^1[3-9]\\d{9}$";
    return [string xhq_predicateMatches:regex];
}

//6~20位密码 字母数字
+ (BOOL)xhq_passFormatCheck:(NSString *)string {
    
    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$";
    return [string xhq_predicateMatches:regex];
}

//身份证
+ (BOOL)xhq_idFormatCheck:(NSString *)string {
    
    NSString *regex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    return [string xhq_predicateMatches:regex];
}

//邮箱检测
+ (BOOL)xhq_emailFormatCheck:(NSString *)string {
    
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [string xhq_predicateMatches:regex];
}

//银行卡检测
+ (BOOL)xhq_bankCardFormatCheck:(NSString *)string {
    
    if (!string || [string isKindOfClass:[NSNull class]] || string.length == 0) {
        return NO;
    }
    
    int oddsum = 0;     //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[string length];
    int lastNum = [[string substringFromIndex:cardNoLength-1] intValue];
    
    NSString *cardNo = [string substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0)
        return YES;
    else
        return NO;
}

//中文检测
+ (BOOL)xhq_cnNameFormatCheck:(NSString *)string {
    NSString * regex = @"^[\u4E00-\u9FA5]*$";
    return [string xhq_predicateMatches:regex];
}

//正则检测
- (BOOL)xhq_predicateMatches:(NSString *)regex {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:self];
}

@end
