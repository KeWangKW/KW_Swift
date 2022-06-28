//
//  KWOCViewController.m
//  ShanghaiCard
//
//  Created by 渴望 on 2018/10/31.
//  Copyright © 2018 渴望. All rights reserved.
//

#import "KWOCViewController.h"
#import "KW_Swift-Swift.h"

@interface KWOCViewController ()

@end

static NSString *const image_return_base = @"icon_return_red";
static NSString *const image_return_white = @"icon_return_white";

@implementation KWOCViewController

- (void)dealloc {
    NSLog(@"dealloc: %@", NSStringFromClass(self.class));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self kw_initData];
    [self kw_initUI];
    [self kw_request];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self kw_reloadData];
    
//    self.navigationController.dy_barStyle = UIStatusBarStyleDefault;
}

- (void)kw_initData {
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.firstLoadHUD = YES;
}

- (void)kw_initUI {
    self.view.backgroundColor = [UIColor Orange];
}

- (void)kw_request {
    
}

- (void)kw_reloadData {
    
}

#pragma mark - getter
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}




//- (void)CallPhoneNum:(NSString *)phone{
//    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phone];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
//}




@end
