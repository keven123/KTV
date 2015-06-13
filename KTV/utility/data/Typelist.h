//
//  Typelist.h
//  KTV
//
//  Created by stevenhu on 15/4/24.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Typelist : NSManagedObject

@property (nonatomic, retain) NSString * zztype;
@property (nonatomic, retain) NSString * zztypeid;
@property (nonatomic, retain) NSString * zztypename;

@end
