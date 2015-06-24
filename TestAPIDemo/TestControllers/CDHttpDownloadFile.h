//
//  CDHttpDownloadFile.h
//  Node.iPad
//
//  Created by Chendi on 15/4/24.
//  Copyright (c) 2015年 Cindy. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CDHttpDownloadFile : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, assign) long long begin;  //  开始的位置

@property (nonatomic, copy) NSString *url;  //   所需要下载文件的远程URL
@property (nonatomic, copy) NSString *destPath;  //  文件的存储路径
@property (nonatomic, readonly, getter = isDownloading) BOOL downloading;  //   是否正在下载(有没有在下载, 只有下载器内部才知道)

@property (nonatomic, readonly, getter = connection) NSURLConnection *connection;  //  连接对象
@property (nonatomic, copy) void (^progressHandler)(double progress);
@property (nonatomic, copy) void (^downloadResultHandler)(BOOL result);

- (void)startDownload;

@end
