//
//  UIView+THDXib.h
//  THDTableDataSourceDemo
//
//  Created by HanXiaoTeng on 2017/12/26.
//  Copyright © 2017年 brefChan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (THDXib)
//layer
@property (nonatomic, assign) IBInspectable BOOL     masksToBounds;
@property (nonatomic, assign) IBInspectable CGFloat  cornerRadius;
@property (nonatomic, assign) IBInspectable CGFloat  borderWidth;
@property (nonatomic, assign) IBInspectable UIColor *borderColor;
@property (nonatomic, assign) IBInspectable CGFloat  defineValue;
//@property (nonatomic, assign) IBInspectable CGFloat  shadowRadius;
//@property (nonatomic, assign) IBInspectable CGFloat  shadowOpacity;
//@property (nonatomic, assign) IBInspectable CGSize  shadowOffset;
//@property (nonatomic, assign) IBInspectable UIColor*  shadowColor;

//背景色
//@property (nonatomic, strong) IBInspectable UIColor * bgColor;
////字体色
//@property (nonatomic, strong) IBInspectable UIColor * textColor;

+ (instancetype)viewFromXib;


@end
