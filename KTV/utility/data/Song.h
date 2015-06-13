//
//  Song.h
//  KTV
//
//  Created by stevenhu on 15/4/24.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Song : NSManagedObject

@property (nonatomic, retain) NSString * addtime;
@property (nonatomic, retain) NSString * bihua;
@property (nonatomic, retain) NSString * channel;
@property (nonatomic, retain) NSString * language;
@property (nonatomic, retain) NSString * movie;
@property (nonatomic, retain) NSString * newsong;
@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) NSString * pathid;
@property (nonatomic, retain) NSString * sex;
@property (nonatomic, retain) NSString * singer;
@property (nonatomic, retain) NSString * singer1;
@property (nonatomic, retain) NSString * songname;
@property (nonatomic, retain) NSString * songpiy;
@property (nonatomic, retain) NSString * spath;
@property (nonatomic, retain) NSString * stype;
@property (nonatomic, retain) NSString * volume;
@property (nonatomic, retain) NSString * word;

@end
