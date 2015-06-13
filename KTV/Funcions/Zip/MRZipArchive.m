//
//  MRZipArchive.m
//  MRuntime
//
//  Created by lucaiguang on 14/11/4.
//  Copyright (c) 2014年 HuaWei. All rights reserved.
//

#import "MRZipArchive.h"
#import "SSZipArchive.h"

@implementation MRZipArchive

+ (BOOL)unzipFileAtPath:(NSString *)path toDestination:(NSString *)destination {
    return [SSZipArchive unzipFileAtPath:path toDestination:destination];
}

+ (BOOL)createZipFileAtPath:(NSString *)path withContentsOfDirectory:(NSString *)directoryPath {
    return [SSZipArchive createZipFileAtPath:path withContentsOfDirectory:directoryPath];
}

@end
