//
//  MRZipArchive.h
//  MRuntime
//
//  Created by lucaiguang on 14/11/4.
//  Copyright (c) 2014年 HuaWei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRZipArchive : NSObject

/**
 *  文件解压
 *
 *  @param path        zip文件目录
 *  @param destination 解压文件目录
 *
 *  @return 是否解压成功
 */
+ (BOOL)unzipFileAtPath:(NSString *)path toDestination:(NSString *)destination;

/**
 *  文件压缩
 *
 *  @param path          创建zip文件的目录 eg:@"/user/zip.zip"
 *  @param directoryPath 需要压缩文件的目录
 *
 *  @return 是否压缩成功
 */
+ (BOOL)createZipFileAtPath:(NSString *)path withContentsOfDirectory:(NSString *)directoryPath;

@end
