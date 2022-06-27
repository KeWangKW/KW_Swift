//
//  ChatCallingWaitViewController.h
//  IMSDK-OC
//
//  Created by 张传章 on 2020/10/9.
//  Copyright © 2020 HCF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QMLineSDK/QMLineSDK.h>
#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CallRoomInfo : JSONModel

@property (nonatomic, copy) NSString <Optional>* _Nullable roomId;

@property (nonatomic, copy) NSString <Optional>* _Nullable password;

@end



typedef enum : NSUInteger {
    ChatCallConnectNone = 0,
    ChatCallConnecting,
    ChatCallConnected,
} ChatCallState;

@interface ChatCallingWaitViewController : UIViewController

@property (nonatomic, strong) CallRoomInfo *roomInfo;

@property (nonatomic, copy) void(^responesed)(BOOL);

- (instancetype)initWithCallType:(ChatCallType)type agent:(QMAgent *)agent;

@end

NS_ASSUME_NONNULL_END


@interface CallingWaitRing : NSObject

+ (instancetype _Nullable )shared;

- (void)playRing:(NSString *_Nullable)ring;
- (void)stopRing;
@end


