//
//  ChatCallingWaitViewController.m
//  IMSDK-OC
//
//  Created by 张传章 on 2020/10/9.
//  Copyright © 2020 HCF. All rights reserved.
//

#import "ChatCallingWaitViewController.h"
#import "Masonry.h"
#import <QMLineSDK/QMLineSDK.h>
#import "QMRemind.h"
#import <QMMeet/QMMeet.h>
#import <AVFoundation/AVFoundation.h>

@interface ChatCallingWaitViewController () <QMMeetViewDelegate>

@property (nonatomic, strong) UIButton *acceptBtn;

@property (nonatomic, strong) UIButton *refuseBtn;

@property (nonatomic, strong) QMAgent *agent;

@property (nonatomic, assign) ChatCallType callType;

@property (nonatomic, assign) ChatCallState connectType;

@property (nonatomic, strong) UIView *waitView;
@property (nonatomic, strong) QMMeetView *meetView;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preLayer;
@property (nonatomic, strong) AVCaptureSession *avSession;

@end

@implementation ChatCallingWaitViewController

- (instancetype)initWithCallType:(ChatCallType)type agent:(QMAgent *)agent {
    if (self = [super init]) {
        
    }
    self.callType = type;
    self.agent = agent;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(customVideoCannel:) name:CUSTOMSRV_VIDEO_REFUSE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(customAcceptVideo:) name:CUSTOMSRV_VIDEO_AcceptVideo object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(customCancelView:) name:CUSTOMSRV_VIDEO_CANCEL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(customInerupt:) name:CUSTOMSRV_VIDEO_INTERRUPT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hangupVideo:) name:CUSTOMSRV_VIDEO_HangupVideo object:nil];
    
    self.connectType = ChatCallConnecting;
    [self setupUI];
    if (self.callType == ChatCall_video_Invite || self.callType == ChatCall_voice_Invite) {
        [self getVideoInfo];
    }
}

- (void)setupUI {
    
    self.waitView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.waitView.backgroundColor = UIColor.blackColor;
    [self.view addSubview:self.waitView];
    
    if (self.callType == ChatCall_video_Invite || self.callType == ChatCall_video_beInvited) {
        [self setCamerView];
    }
    
    CGFloat width = 72.0*kScale6;
    CGFloat marginX = 72.0*kScale6;
    CGFloat bottom = -(kSafeArea + 80*kScale6);
    
    /**接听、挂断---按钮*/
    if (self.callType == ChatCall_video_beInvited || self.callType == ChatCall_voice_beInvited) {
        _acceptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _acceptBtn.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 120)/3, [[UIScreen mainScreen] bounds].size.height - 120, 60, 60);
        _acceptBtn.backgroundColor = [UIColor clearColor];
        [_acceptBtn setBackgroundImage:[UIImage imageNamed:@"call_accept"] forState:UIControlStateNormal];
        [_acceptBtn addTarget:self action:@selector(acceptAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.waitView addSubview:_acceptBtn];
        [_acceptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.waitView).offset(marginX);
            make.height.width.mas_equalTo(width);
            make.bottom.equalTo(self.waitView).offset(bottom);
        }];
    }
    
    _refuseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _refuseBtn.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 120)/3*2+60, [[UIScreen mainScreen] bounds].size.height - 120, 60, 60);
    _refuseBtn.backgroundColor = [UIColor clearColor];
    [_refuseBtn setBackgroundImage:[UIImage imageNamed:@"call_hangup"] forState:UIControlStateNormal];
    [_refuseBtn addTarget:self action:@selector(refuseAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.waitView addSubview:_refuseBtn];
    
    [_refuseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(width);
        make.bottom.equalTo(self.waitView).offset(bottom);
        if (self.callType == ChatCall_video_Invite || self.callType == ChatCall_voice_Invite) {
            make.centerX.equalTo(self.waitView);
        } else {
            make.right.equalTo(self.waitView).offset(-marginX);
        }
    }];
    
    
    /**头像及名称*/
    UIImageView *iconImage = [UIImageView new];
    iconImage.layer.cornerRadius = 8;
    iconImage.backgroundColor = [UIColor clearColor];
    [self.waitView addSubview:iconImage];
    if (self.agent.icon_url.length > 0) {
        [iconImage sd_setImageWithURL:[NSURL URLWithString:self.agent.icon_url] placeholderImage:[UIImage imageNamed:@"qm_default_agent"]];
    }
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.callType == ChatCall_video_Invite || self.callType == ChatCall_video_beInvited) {
            make.right.equalTo(self.waitView).offset(-30);
            make.top.mas_equalTo(80*kScale6);
        } else {
            make.centerX.equalTo(self.waitView);
            make.top.mas_equalTo(120*kScale6);
        }
        make.height.width.mas_equalTo(120*kScale6);
    }];
    
    UILabel *customerLab = [UILabel new];
    customerLab.text = [NSString stringWithFormat:@"客服 %@",self.agent.name];
    customerLab.textColor = UIColor.whiteColor;
    customerLab.font = [UIFont systemFontOfSize:20];
    [self.waitView addSubview:customerLab];
    [customerLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(iconImage);
        make.top.equalTo(iconImage.mas_bottom).offset(20);
    }];
    
    UILabel *tipLab = [UILabel new];
    NSString *tipStr = @"";
    if (self.callType == ChatCall_voice_beInvited) {
        tipStr = @"邀请您进行语音通话...";
    } else if (self.callType == ChatCall_video_beInvited) {
        tipStr = @"邀请您进行视频通话...";
    } else {
        tipStr = @"正在等待客服接听...";
    }
    tipLab.text = tipStr;
    tipLab.textColor = UIColor.whiteColor;
    tipLab.font = [UIFont systemFontOfSize:13];
    [self.waitView addSubview:tipLab];
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(iconImage);
        make.top.equalTo(customerLab.mas_bottom).offset(10);
    }];
        
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.callType == ChatCall_video_beInvited || self.callType == ChatCall_voice_beInvited) {
        [CallingWaitRing.shared playRing:@"video_chat_tip_receiver"];
    } else {
        [CallingWaitRing.shared playRing:@"video_chat_tip_sender"];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setCamerView {
    [self.waitView.layer addSublayer:self.preLayer];
    [_avSession startRunning];
}

- (AVCaptureVideoPreviewLayer *)preLayer {
    if (!_preLayer) {
        AVCaptureSession *session = [AVCaptureSession new];
        session.sessionPreset = AVCaptureSessionPresetMedium;
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionFront];
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        if (!input) {
            
            return nil;
        }
        
        [session addInput:input];
        AVCaptureVideoDataOutput *output = [AVCaptureVideoDataOutput new];
        [session addOutput:output];
    //    dispatch_queue_t queue = dispatch_queue_create("videoInput", NULL);
    //    [output setSampleBufferDelegate:self queue:queue];
        output.videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA], kCVPixelBufferPixelFormatTypeKey, [NSNumber numberWithInt:320], (id)kCVPixelBufferWidthKey, [NSNumber numberWithInt:240], (id)kCVPixelBufferHeightKey, nil];
        _preLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
        _preLayer.frame = self.view.bounds;
        _preLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
        _avSession = session;
    }
    
    return _preLayer;
    
}

- (void)customVideoCannel:(NSNotification *)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [QMRemind showMessage:@"对方已拒绝"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self poptoLastController];
        });
    });
}

- (void)customAcceptVideo:(NSNotification *)notif {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeCamerView];
        [self.waitView removeFromSuperview];
        if (![self.view.subviews containsObject:self.meetView]) {
            [self.view addSubview:self.meetView];
        }
    });
}

- (void)customInerupt:(NSNotification *)notif {
    dispatch_async(dispatch_get_main_queue(), ^{
        [QMRemind showMessage:@"视频中断了"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.meetView leave];
            [self poptoLastController];
        });
    });
}

- (void)hangupVideo:(NSNotification *)noti {
    dispatch_async(dispatch_get_main_queue(), ^{
        [QMRemind showMessage:@"对方挂断了视频通话"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self poptoLastController];
        });
    });}

- (void)customCancelView:(NSNotification *)notif {
    dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self poptoLastController];
        });
    });
    
}

- (void)poptoLastController {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeCamerView];
        [self.meetView leave];
        [CallingWaitRing.shared stopRing];
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)removeCamerView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [CallingWaitRing.shared stopRing];
        [self.preLayer removeFromSuperlayer];
        [self.avSession stopRunning];
    });
}


- (void)acceptAction:(UIButton *)sender {
    [QMConnect sdkAcceptVideo:^{
        [self showVideoViewIsVideo:YES];
        [self customAcceptVideo:nil];
    } failBlock:^{
        [self poptoLastController];
    }];
}

- (void)refuseAction:(UIButton *)sender {
//    if (self.responesed) {
//        self.responesed(NO);
//    }
//
    if (self.callType == ChatCall_video_beInvited || self.callType == ChatCall_voice_beInvited) {
        [QMConnect sdkRefuseVideo:^{
            [self poptoLastController];
        } failBlock:^{
            [self poptoLastController];
        }];
    } else {
        [QMConnect sdkCannelVideo:^{
            [self poptoLastController];
        } failBlock:^{
            [self poptoLastController];
        }];
    }
}



#pragma mark -- 视频

- (void)getVideoInfo {
    
    BOOL isVideo = YES;
    NSString *type = @"video";
    if (self.callType == ChatCall_voice_Invite) {
        isVideo = NO;
        type = @"voice";
    }
    
    
    [QMConnect sdkGetVideo:type Completion:^(NSDictionary *dict) {

        dispatch_async(dispatch_get_main_queue(), ^{
            if ([dict[@"Succeed"] boolValue] == 1) {
                CallRoomInfo *info = [[CallRoomInfo alloc] initWithDictionary:dict error:nil];
                self.roomInfo = info;
                [self showVideoViewIsVideo:isVideo];
                
            }
        });
    } failure:^(NSError *err) {
        NSLog(@"err = ss");
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *msg = @"";
            if ([err isKindOfClass:[NSString class]]) {
                msg = (NSString *)err;
                if ([msg isEqualToString:@"agent_videoing"]) {
                    msg = @"对方正在通话中,请稍后";
                }
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self setErrorMsg:msg];
            });
        });
    }];

}

- (void)setErrorMsg:(NSString *)msg {
    if (msg.length == 0) {
        msg = @"开启视频聊天失败";
        if (self.callType == ChatCall_voice_Invite) {
            msg = @"开启音频聊天失败";
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [QMRemind showMessage:msg];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:^{
            [self poptoLastController];
        }];
    });
}

- (void)showVideoViewIsVideo:(BOOL)isVideo {
    dispatch_async(dispatch_get_main_queue(), ^{
        QMMeetConferenceOptions *option = [QMMeetConferenceOptions fromBuilder:^(QMMeetConferenceOptionsBuilder *builder) {

            if (self.callType == ChatCall_voice_beInvited || self.callType == ChatCall_voice_Invite) {
                builder.audioOnly = YES;
            }
            builder.serverURL = [NSURL URLWithString:@"https://kfvideo.7moor.com"];
            builder.room = self.roomInfo.roomId;
//            builder.token = pwd;
        }];
        [QMMeet.sharedInstance setRoomPassword:self.roomInfo.password];
        self.connectType = ChatCallConnected;
        [self.meetView join:option];
    });
    
}

- (QMMeetView *)meetView {
    if (!_meetView) {
        _meetView = [[QMMeetView alloc] initWithFrame:self.view.bounds];
        _meetView.delegate = self;

    }
    return _meetView;
}

- (void)_onQMMeetViewDelegateEvent:(NSString *)name
                             withData:(NSDictionary *)data {

    NSLog(
        @"[%s:%d] QMMeetViewDelegate %@ %@",
        __FILE__, __LINE__, name, data);
}

- (void)conferenceJoined:(NSDictionary *)data {
    [self _onQMMeetViewDelegateEvent:@"CONFERENCE_JOINED" withData:data];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        QMMeet *meet = [QMMeet sharedInstance];
        [meet setRoomPassword:self.roomInfo.password];
    });
}

- (void)conferenceTerminated:(NSDictionary *)data {
    [self _onQMMeetViewDelegateEvent:@"CONFERENCE_TERMINATED" withData:data];
    [self.meetView removeFromSuperview];
    self.meetView = nil;
    [self removeCamerView];
    NSString *originator = @"customer";
    if (self.callType == ChatCall_video_beInvited || self.callType == ChatCall_voice_beInvited) {
         originator = @"agent";
    }
    [QMConnect sdkHangupVideo:originator successBlock:nil failBlock:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)conferenceWillJoin:(NSDictionary *)data {
    [self _onQMMeetViewDelegateEvent:@"CONFERENCE_WILL_JOIN" withData:data];
}

- (void)enterPictureInPicture:(NSDictionary *)data {
    [self _onQMMeetViewDelegateEvent:@"ENTER_PICTURE_IN_PICTURE" withData:data];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

@implementation CallingWaitRing

{
    AVAudioPlayer *playerBox;
}

+ (instancetype)shared {
    static CallingWaitRing *_callWaitMgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _callWaitMgr = [CallingWaitRing new];
    });
    return _callWaitMgr;
}

- (void)playRing:(NSString *)ring {
    if (playerBox) [playerBox stop];
    if (ring.length == 0) {
        return;
    }
    NSString *path = [NSBundle.mainBundle pathForResource:ring ofType:@"aac"];
    NSURL *url = [NSURL URLWithString:path];
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    if (player) {
        player.numberOfLoops = 20;
        [player play];
        playerBox = player;
    }
}

- (void)stopRing {
    if (playerBox) {
        [playerBox stop];
    }
    playerBox = nil;
}

@end

@implementation CallRoomInfo


@end
