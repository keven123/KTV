//
//  Singer.h
//  KTV
//
//  Created by stevenhu on 15/4/24.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Singer : NSManagedObject

@property (nonatomic, retain) NSString * area;
@property (nonatomic, retain) NSString * pingyin;
@property (nonatomic, retain) NSString * s_bi_hua;
@property (nonatomic, retain) NSString * singer;

@end
