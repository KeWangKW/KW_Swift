//
//  SetUpTZImagePicker.m
//  KW_Swift
//
//  Created by 渴望 on 2022/6/15.
//  Copyright © 2022 guan. All rights reserved.
//

#import "SetUpTZImagePicker.h"
#import "TZImagePickerController.h"

@implementation SetUpTZImagePicker

+ (void)setBlcok:(TZImagePickerController *)vc andBlock:(void(^)(NSArray<UIImage *>* ,NSArray * ,bool))block{
    
    [vc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        block(photos ,assets ,isSelectOriginalPhoto);
    }];
    
}

+ (void)setVideoBlcok:(TZImagePickerController *)vc andBlock:(void(^)(UIImage * ,PHAsset *))block{
    
    [vc setDidFinishPickingVideoHandle:^(UIImage *coverImage, PHAsset *asset) {
        block(coverImage ,asset);
    }];
    
}

@end
