//
//  UIView+THDXib.m
//  THDTableDataSourceDemo
//
//  Created by HanXiaoTeng on 2017/12/26.
//  Copyright © 2017年 brefChan. All rights reserved.
//

#import "UIView+THDXib.h"
#import <objc/runtime.h>
@implementation UIView (THDXib)

+ (instancetype)viewFromXib
{
    Class viewClass = [self class];
    NSString *viewClassName = NSStringFromClass(viewClass);
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:viewClassName owner:nil options:nil];
    
    for (id nibItem in nibArray)
    {
        if ([nibItem isMemberOfClass:viewClass])
        {
            return nibItem;
        }
    }
    
    return nil;
}
- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
}

- (void)setMasksToBounds:(BOOL)masksToBounds
{
    self.layer.masksToBounds = YES;
}

- (BOOL)masksToBounds
{
    return self.layer.masksToBounds;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}

- (void)setDefineValue:(CGFloat)defineValue
{
    objc_setAssociatedObject(self, @selector(defineValue), @(defineValue),OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}

- (CGFloat)borderWidth
{
    return self.layer.borderWidth;
}

- (UIColor *)borderColor
{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (CGFloat)defineValue
{
    return [objc_getAssociatedObject(self, @selector(defineValue)) floatValue];
}

//- (CGFloat)shadowRadius
//{
//    return self.layer.shadowRadius;
//}
//
//- (CGFloat)shadowOpacity
//{
//    return self.layer.shadowOpacity;
//}
//
//- (CGSize)shadowOffset
//{
//    return self.layer.shadowOffset;
//}
//
//- (UIColor *)shadowColor
//{
//
//    return [UIColor colorWithCGColor:self.layer.shadowColor];
//}


//- (UIColor *)bgColor
//{
//    return self.backgroundColor;
//}
//-(void)setBgColor:(UIColor *)bgColor
//{
//    self.backgroundColor = [UIColor redColor];
//}

//- (UIColor *)textColor
//{
//    return self.textColor;
//}
//-(void)setTextColor:(UIColor *)textColor
//{
//    self.textColor = [UIColor redColor];
//}

@end
