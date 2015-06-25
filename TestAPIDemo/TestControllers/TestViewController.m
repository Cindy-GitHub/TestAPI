//
//  TestViewController.m
//  TestAPIDemo
//
//  Created by Cindy on 15/6/24.
//  Copyright (c) 2015年 Cindy. All rights reserved.
//

#import "TestViewController.h"
#import "CDHttpRequestUnity.h"

const NSString *CDRequestURLContentString = @"";

@interface TestViewController ()
@property (nonatomic,strong) CDHttpRequestUnity *requestManager;
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //  init  request manager
    _requestManager = [[CDHttpRequestUnity alloc] init];
    _requestManager.url = [NSString stringWithFormat:@"%@",CDRequestURLContentString];
    _requestManager.requestWay = CDRequestWayJSONData;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _requestManager.progressHandler = ^(double progress) {
        NSLog(@"request  progress : %f",progress);
    };
    
    _requestManager.requestResultHandler = ^(BOOL result,NSData *JsonData) {
        NSLog(@"request  result  :  %zi",result);
        NSLog(@"JsonData : %@",JsonData);
    };
    

}

- (IBAction)buttonPressEvent:(UIButton *)sender
{
    //  开始请求
    [_requestManager startRequest];
    
    NSLog(@"send  request !");
}


#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
