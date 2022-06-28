//
//  OCTestVC.m
//  KW_Swift
//
//  Created by 渴望 on 2022/6/27.
//  Copyright © 2022 guan. All rights reserved.
//

#import "OCTestVC.h"
#import "KW_Swift-Swift.h"

@interface OCTestVC ()

@end

@implementation OCTestVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:true];
    [self nav_color_clear];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, kScreenWidth()/2, 100)];
    lab.backgroundColor = [UIColor HexColorWithStr:@"222222"];
    lab.textColor = [UIColor Orange];
    [self.view addSubview:lab];
    
    // Do any additional setup after loading the view.
}



@end
