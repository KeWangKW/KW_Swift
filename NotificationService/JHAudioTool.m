//
//  JHAudioTool.m
//  JHKit
//
//  Created by HaoCold on 2018/12/18.
//  Copyright © 2018 HaoCold. All rights reserved.
//

#import "JHAudioTool.h"
#import <AVFoundation/AVFoundation.h>
//#import "lame.h"

@interface JHAudioTool()
@property (nonatomic,  assign) BOOL  stop;
@end

@implementation JHAudioTool

+ (instancetype)shareTool
{
    static JHAudioTool *tool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[JHAudioTool alloc] init];
    });
    return tool;
}

+ (void)mergeAudios:(NSArray *)paths destnation:(NSString *)outputPath finish:(JHAudioToolFinishBlock)finish
{
    if (paths.count == 0 || outputPath == nil) {
        return;
    }
    
    AVMutableComposition *composition = [AVMutableComposition composition];
    // 设置音频合并音轨
    AVMutableCompositionTrack *compositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    // 开始时间
    CMTime beginTime = kCMTimeZero;
    NSError *error = nil;
    for (NSString *path in paths) {
        
        NSURL *url;
        if ([path isKindOfClass:[NSURL class]]) {
            url = (NSURL *)path;
        }else{
            url = [NSURL fileURLWithPath:path];
        }
        
        // 音频文件资源
        AVURLAsset *asset = [AVURLAsset assetWithURL:url];
        // 需要合并的音频文件的区间
        CMTimeRange timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
        // ofTrack 音频文件内容
        AVAssetTrack *track = [asset tracksWithMediaType:AVMediaTypeAudio].firstObject;
        //
        [compositionTrack insertTimeRange:timeRange ofTrack:track atTime:beginTime error:&error];
        if (error) {
            NSLog(@"error:%@",error);
        }
        
        beginTime = CMTimeAdd(beginTime, asset.duration);
    }
    
    [[NSFileManager defaultManager] removeItemAtPath:outputPath error:nil];
    
    // 导出合并的音频
    // presetName 与 outputFileType 要对应
    AVAssetExportSession *export = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetAppleM4A];
    if (export == nil) {
        return;
    }
    
    export.outputURL = [NSURL fileURLWithPath:outputPath];
    export.outputFileType = AVFileTypeAppleM4A;
    export.shouldOptimizeForNetworkUse = YES;
    [export exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finish) {
                if(export.status == AVAssetExportSessionStatusCompleted) {
                    AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:outputPath]];
                    int64_t seconds = asset.duration.value / asset.duration.timescale;
                    
                    finish(YES, seconds);
                }else if(export.status == AVAssetExportSessionStatusFailed){
                    NSLog(@"export failed:%@",error);
                    finish(NO, 0);
                }
            }
        });
    }];
}

@end
