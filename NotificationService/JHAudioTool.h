//
//  JHAudioTool.h
//  JHKit
//
//  Created by HaoCold on 2018/12/18.
//  Copyright © 2018 HaoCold. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^JHAudioToolFinishBlock)(BOOL success, int64_t seconds);
typedef void(^JHAudioToolTranscodeBlock)(BOOL success);

@interface JHAudioTool : NSObject

+ (instancetype)shareTool;

/**
 Merge audios.(from .caf or .wav to .m4a) 合并音频。(从.caf或.wav到.m4a)
 
 @param paths source audio path.
 @param outputPath output path of audio.
 
 */
+ (void)mergeAudios:(NSArray *)paths destnation:(NSString *)outputPath finish:(JHAudioToolFinishBlock)finish;


@end
