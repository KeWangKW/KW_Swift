//
//  SetUpTZImagePicker.h
//  KW_Swift
//
//  Created by 渴望 on 2022/6/15.
//  Copyright © 2022 guan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "TZImagePickerController.h"

NS_ASSUME_NONNULL_BEGIN
@class TZImagePickerController;
@interface SetUpTZImagePicker : NSObject

+ (void)setBlcok:(TZImagePickerController *)vc andBlock:(void(^)(NSArray<UIImage *>* ,NSArray * ,bool))block;
+ (void)setVideoBlcok:(TZImagePickerController *)vc andBlock:(void(^)(UIImage * ,PHAsset *))block;
@end

NS_ASSUME_NONNULL_END
