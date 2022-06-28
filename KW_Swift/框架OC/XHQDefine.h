//
//  XHQDefine.h
//  ShanghaiCard
//
//  Created by 渴望 on 2018/10/30.
//  Copyright © 2018 渴望. All rights reserved.
//
#ifndef XHQDefine_h
#define XHQDefine_h

#pragma mark - 打印日志
//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#   define XHQLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define XHQLog(...)
#endif

#define kDeviceSystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]


#pragma mark - 强弱引用
//弱引用
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

//强引用
#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif


#pragma mark - 单例创建
//构建单例类
#define XHQ_SHARED_H(cls) +(instancetype)shared##cls;

#define XHQ_SHARED_M(cls) \
+ (instancetype)shared##cls { \
static cls *obj = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
obj = [[cls alloc]init]; \
}); \
return obj; \
}

#define Nav_Height ((WH_ISIOS13?([UIApplication sharedApplication].keyWindow.windowScene.statusBarManager.statusBarFrame.size.height):([[UIApplication sharedApplication] statusBarFrame].size.height))+44)

/** 屏幕尺寸 */
static inline CGSize kScreenSize() {
    return [[UIScreen mainScreen] bounds].size;
}

/** 屏幕宽 */
static inline CGFloat kScreenWidth() {
    return kScreenSize().width;
}

/** 屏幕高 */
static inline CGFloat kScreenHeight() {
    return kScreenSize().height;
}


/** 基于iPhone6适配屏幕尺寸 */
static inline CGFloat kAdapt(CGFloat x) {
    return ((x) / 375.f * kScreenWidth());
}

/** 是否是5 SE */
static inline BOOL kIsIPhone5SE() {
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return NO;
    }
    return kScreenHeight() == 568.f;
}

/** 是否是iPhoneX系列 */
static inline BOOL kIsIPhoneX() {
    BOOL iPhoneX = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneX;
    }
    
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneX = YES;
        }
    }
    
    return iPhoneX;
}


/** 导航栏高度 */
static inline CGFloat kNavigationBarHeight() {
    return 44.f;
}

/** 状态栏高度 */
static inline CGFloat kStatusBarHeight() {
    if (@available(iOS 13.0, *)) {
        return [UIApplication sharedApplication].keyWindow.windowScene.statusBarManager.statusBarFrame.size.height;
    }else{
        return [[UIApplication sharedApplication] statusBarFrame].size.height;
    }
//    return [[UIApplication sharedApplication] statusBarFrame].size.height;
}

/** 导航栏+状态栏高度 */
static inline CGFloat kNavigationStatusHeight() {
    return (kStatusBarHeight() + kNavigationBarHeight());
}

/** 底部指示栏高度 */
static inline CGFloat kHomeIndicatorHeight() {
    return kIsIPhoneX() ? 34.f : 0.f;
}

/** 底部标签栏高度 */
static inline CGFloat kTabBarHeight() {
    return (kHomeIndicatorHeight() + 49.f);
}

#endif /* XHQDefine_h */
