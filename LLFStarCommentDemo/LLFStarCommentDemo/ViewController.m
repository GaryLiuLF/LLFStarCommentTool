//
//  ViewController.m
//  LLFStarCommentDemo
//
//  Created by Apple on 16/11/29.
//  Copyright © 2016年 LLF. All rights reserved.
//

#import "ViewController.h"
#import "LLFStarView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect rect = CGRectMake(20, 100, 300, 50);
    LLFStarView *starView = [[LLFStarView alloc]initWithFrame:rect
                                                     starSize:CGSizeZero
                                                     starType:LLFStarTypeFloat];
    starView.starBlock = ^(NSString *value) {
        NSLog(@"%@",value);
    };
    [self.view addSubview:starView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
