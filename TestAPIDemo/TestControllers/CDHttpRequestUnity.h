//
//  CDHttpRequestUnity.h
//  TestAPIDemo
//
//  Created by Cindy on 15/6/25.
//  Copyright (c) 2015年 Cindy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef  enum CDEnumRequestWays{
    CDRequestWayJSONData = 0,
    CDRequestWayDownloadFile
}CDEnumRequestWays;


@interface CDHttpRequestUnity : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, assign) long long begin;  //  开始的位置

@property (nonatomic, copy) NSString *url;  //   所需要下载文件的远程URL
@property (nonatomic, readonly, getter = isDownloading) BOOL downloading;  //   是否正在下载(有没有在下载, 只有下载器内部才知道)
@property (nonatomic) CDEnumRequestWays  requestWay;

@property (nonatomic, copy) NSString *destPath;  //  文件的存储路径 (如果选择RequestWayDownloadFile方式请求数据，就必须设置该路径)

@property (nonatomic, readonly, getter = connection) NSURLConnection *connection;  //  连接对象
@property (nonatomic, copy) void (^progressHandler)(double progress);
@property (nonatomic, copy) void (^requestResultHandler)(BOOL result,NSData *JsonData);

- (void)startRequest;


@end
