//
//  TestViewController.m
//  TestAPIDemo
//
//  Created by Cindy on 15/6/24.
//  Copyright (c) 2015年 Cindy. All rights reserved.
//

#import "TestViewController.h"
#import "CDHttpDownloadFile.h"

const NSString *CDRequestURLContentString = @"";

@interface TestViewController ()

@property (nonatomic,strong) CDHttpDownloadFile *requestManager;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //  init  request manager
    _requestManager = [[CDHttpDownloadFile alloc] init];
    _requestManager.url = [NSString stringWithFormat:@"%@",CDRequestURLContentString];
    _requestManager.requestWay = CDRequestWayJSONData;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //  开始请求
    [_requestManager startRequest];
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
