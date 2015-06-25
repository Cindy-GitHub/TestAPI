//
//  CDHttpDownloadFile.m
//  Node.iPad
//
//  Created by Chendi on 15/4/24.
//  Copyright (c) 2015年 Cindy. All rights reserved.
//

#import "CDHttpDownloadFile.h"

@interface CDHttpDownloadFile()

@property (nonatomic , strong) NSFileHandle *writeHandle;  //  写数据的文件句柄
@property (nonatomic, assign) long long totleLenght;  //  文件总长度
@property (nonatomic, assign) long long currentLength;  //  当前已下载数据的长度
@property (nonatomic, retain) NSMutableData *receiveData;

@end

@implementation CDHttpDownloadFile
- (NSFileHandle *)writeHandle
 {
    if (_writeHandle == nil) {
         _writeHandle = [NSFileHandle fileHandleForWritingAtPath:self.destPath];
   }
    return _writeHandle;
}

- (void)startRequest
{
    NSURL *url = [NSURL URLWithString:self.url];
    if (self.destPath) {
        [[NSFileManager defaultManager] createFileAtPath:self.destPath contents:nil attributes:nil];
        NSLog(@"fileExistsAtPath : %zi",[[NSFileManager defaultManager] fileExistsAtPath:self.destPath]);
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    NSString *value = [NSString stringWithFormat:@"bytes=%lld-%lld", self.begin + self.currentLength, self.end];
//    [request setValue:value forHTTPHeaderField:@"Range"];
    _connection = [NSURLConnection connectionWithRequest:request delegate:self];
    _downloading = YES;
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
    NSLog(@"\n\n");
    NSLog(@"++++++++++++++++++++++++++   New Request   ++++++++++++++++++++++++");
    NSLog(@"MIMEType : %@",response.MIMEType);
    NSLog(@"response URL : %@",response.URL);
    NSLog(@"suggestedFilename : %@",response.suggestedFilename);
    NSLog(@"expectedContentLength1 : %zi",response.expectedContentLength);
    _receiveData = nil;
    
    switch (self.requestWay) {
        case CDRequestWayDownloadFile:
        {
            self.totleLenght = response.expectedContentLength;
        }
            break;
        case CDRequestWayJSONData:
        {
            _receiveData = [[NSMutableData alloc] init];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    switch (self.requestWay) {
        case CDRequestWayDownloadFile:
        {
            [self.writeHandle seekToFileOffset:self.begin + self.currentLength];  // 移动到文件的尾部
            [self.writeHandle writeData:data];  // 从当前移动的位置(文件尾部)开始写入数据
            self.currentLength += data.length;  // 累加长度
        }
            break;
        case CDRequestWayJSONData:
        {
            [_receiveData appendData:data];
        }
            break;
        default:
            NSLog(@"RequestDataWays  the  value  is  exception !");
            break;
    }

    
    // 打印数据请求完成的进度
    double progress = (double)self.currentLength / (self.totleLenght - self.begin);
    if (self.progressHandler) {
        self.progressHandler(progress);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connectionDidFinishLoading !");
    if (self.downloadResultHandler) {
        self.downloadResultHandler(YES,_receiveData);
    }
    
    
    switch (self.requestWay) {
        case CDRequestWayDownloadFile:
        {
            // 清空属性值
            self.currentLength = 0;
            // 关闭连接(不再输入数据到文件中)
            [self.writeHandle closeFile];
            self.writeHandle = nil;
            _downloading = NO;
        }
            break;
        case CDRequestWayJSONData:
        {
            _receiveData = nil;
        }
            break;
        default:
            NSLog(@"RequestDataWays  the  value  is  exception !");
            break;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError : %@",error);
    if (self.downloadResultHandler) {
        self.downloadResultHandler(NO,_receiveData);
    }
    
    _receiveData = nil;
    
    // 清空属性值
    self.currentLength = 0;
    
    // 关闭连接(不再输入数据到文件中)
    [self.writeHandle closeFile];
    self.writeHandle = nil;
    _downloading = NO;
}

@end
