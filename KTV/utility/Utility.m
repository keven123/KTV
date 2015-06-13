//
//  Utility.m
//  ZZKTV
//
//  Created by stevenhu on 15-3-22.
//  Copyright (c) 2015年 zz. All rights reserved.
//
//fmdb
#import "Utility.h"
#define DBPATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"DB.sqlite"]

@interface Utility()
@property (nonatomic, copy)NSString *modelName;
@property (nonatomic, copy)NSString *dbFileName;
@end
static Utility *shareInstance=nil;
@implementation Utility
+ (instancetype)instanceShare {
    static  dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!shareInstance) {
            shareInstance=[[self alloc]init];
           
        }
    });
    return shareInstance;
}

- (id)init {
    if (self=[super init]) {
        if (![[NSUserDefaults standardUserDefaults]objectForKey:@"YIDIAN_COUNT"]) {
            [[ NSUserDefaults standardUserDefaults]setValue:@0 forKey:@"YIDIAN_COUNT"];
        }

        NSNumber *count=[[NSUserDefaults standardUserDefaults]objectForKey:@"YIDIAN_COUNT"];
        _yidianBadge=[NSString stringWithFormat:@"%@",count];
        
    }
    return self;
}

- (void)clearYidianToZero {
    [[ NSUserDefaults standardUserDefaults]setValue:@0 forKey:@"YIDIAN_COUNT"];
    _yidianBadge=@"0";
}

+ (iphoneModel)whatIphoneDevice {
    if (IS_IPHONE_4_OR_LESS) {
        NSLog(@"4s");
        return isiPhone4s;
    } else if (IS_IPHONE_5) {
        NSLog(@"iphone5");
        return isiphone5s;
        
        
    } else if (IS_IPHONE_6) {
        NSLog(@"iphone6");
        return isiphone6;
        
        
    } else if (IS_IPHONE_6P) {
        NSLog(@"iphone6s");
        return isiphone6p;
    }
    
    return unkownPhone;
    
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone  {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance=[super allocWithZone:zone];
        NSLog(@"path is %@",DBPATH);
    });
    return shareInstance;
}


+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)setupEnvModel:(NSString *)model DbFile:(NSString *)filename {
    
}

+ (float)user_iosVersion {
    return [[UIDevice currentDevice].systemVersion floatValue];
}

+ (NSString *)chineseToPinYin:(NSString *)string {
    NSMutableString *muString=[string mutableCopy];
    CFStringTransform((CFMutableStringRef)muString, NULL, kCFStringTransformToLatin, NO);
    CFStringTransform((CFMutableStringRef)muString, NULL, kCFStringTransformStripDiacritics, NO);
    return [muString copy];
}

+ (BOOL)isIncludeChineseInString:(NSString*)str {
    for (int i=0; i<str.length; i++) {
        unichar ch = [str characterAtIndex:i];
        if (0x4e00 < ch  && ch < 0x9fff) {
            return true;
        }
    }
    return false;
}

+ (NSString*)shouZiFu:(NSString*)string {
    return  [[Utility chineseToPinYin:string]substringToIndex:1];
}

#define DEFAULT_VOID_COLOR [UIColor whiteColor]  
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

#pragma mark - coredata operation
- (void)addIntoDataSource:(importDataResult)completed {
    [self initCoreDataStack:^(BOOL isSuccess) {
            completed(isSuccess);
    }];

}

- (void)initCoreDataStack:(importDataResult)zzBlock {
    BOOL result=YES;
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _bgObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_bgObjectContext setPersistentStoreCoordinator:coordinator];
        
        _mainObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_mainObjectContext setParentContext:_bgObjectContext];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        //纪录但前收藏数量（id)
        if (![[NSUserDefaults standardUserDefaults]objectForKey:@"COLLECTION_RCID"]) {
           [[ NSUserDefaults standardUserDefaults]setValue:@0 forKey:@"COLLECTION_RCID"];
        }

        [self importDataForSongs:^(NSError *error) {
            if (error) {
                __block BOOL a=result;
                a&=NO;
            }
        }];
        [self importDataForSingers:^(NSError *error) {
            if (error) {
                __block BOOL a=result;
                a &=NO;
            }
        }];
        [self importDataForType:^(NSError *error) {
            if (error) {
                __block BOOL a=result;
                a &=NO;
            }
        }];
        [self.bgObjectContext reset];
        
        zzBlock(result);
        NSLog(@"data import done!");
    });
    
    
    
}

- (NSManagedObjectContext *)createPrivateObjectContext {
    NSManagedObjectContext *ctx=[[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [ctx setParentContext:_mainObjectContext];
    return ctx;
}

- (NSManagedObjectModel*)managedObjectModel {
    NSManagedObjectModel *managedObjectModel;
    NSURL *modleURL=[[NSBundle mainBundle]URLForResource:@"SongList" withExtension:@"momd"];
    managedObjectModel=[[NSManagedObjectModel alloc]initWithContentsOfURL:modleURL];
    return managedObjectModel;
    
}

- (NSPersistentStoreCoordinator*)persistentStoreCoordinator {
    NSPersistentStoreCoordinator *persistentStoreCoordinator=nil;
    NSURL *storeURL=[NSURL fileURLWithPath:DBPATH isDirectory:NO];
    NSError *error=nil;
    persistentStoreCoordinator=[[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return persistentStoreCoordinator;
}


- (NSError*)save:(OperationResult)handler {
    NSError *error;
    if ([_mainObjectContext hasChanges]) {
        [_mainObjectContext save:&error];
        [_bgObjectContext performBlock:^{
            __block NSError *inner_error=nil;
            [_bgObjectContext save:&inner_error];
            if (handler) {
                [_mainObjectContext performBlock:^{
                    handler(error);
                }];
            }
        }];
    }
    return error;
}

- (NSError*)importDataForSongs:(OperationResult)handler; {
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"SONGLISTIMPORTED"]boolValue]) {
        if (handler) {
            handler(nil);
        }
        return nil;
    }
    //-com.apple.CoreData.SQLDebug 1
    // import songlist
    //read file
    NSString *txtPath=[[NSBundle mainBundle]pathForResource:@"songlist.txt" ofType:nil];
    NSFileHandle *fileHandle=[NSFileHandle fileHandleForReadingAtPath:txtPath];
    NSString *str=[[NSString alloc]initWithData:[fileHandle readDataToEndOfFile] encoding:NSUTF8StringEncoding];
    NSArray *lines=[str componentsSeparatedByString:@"\t\r\n"];
    long acount=0;
    long maxSubMitCount=20000;
    long reserveCount=lines.count;
    for (NSString *lineStr in lines) {
        @autoreleasepool {
            acount++;
            NSArray *lineArry=[lineStr componentsSeparatedByString:@"\t"];
            if  (lineArry.count !=17) {
                NSError *error;
                [self.bgObjectContext save:&error];
                reserveCount-=acount;
                acount=0;
                continue;
            }
            NSManagedObject  *songInfo=[NSEntityDescription insertNewObjectForEntityForName:@"Song" inManagedObjectContext:self.bgObjectContext];
            [songInfo setValue:lineArry[0] forKey:@"number"];
            [songInfo setValue:lineArry[1] forKey:@"songname"];
            [songInfo setValue:lineArry[2] forKey:@"singer"];
            [songInfo setValue:lineArry[3] forKey:@"singer1"];
            [songInfo setValue:lineArry[4] forKey:@"songpiy"];
            [songInfo setValue:lineArry[5] forKey:@"word"];
            [songInfo setValue:lineArry[6] forKey:@"language"];
            [songInfo setValue:lineArry[7] forKey:@"volume"];
            [songInfo setValue:lineArry[8] forKey:@"channel"];
            [songInfo setValue:lineArry[9] forKey:@"sex"];
            [songInfo setValue:lineArry[10] forKey:@"stype"];
            [songInfo setValue:lineArry[11] forKey:@"newsong"];
            [songInfo setValue:lineArry[12] forKey:@"movie"];
            [songInfo setValue:lineArry[13] forKey:@"pathid"];
            [songInfo setValue:lineArry[14] forKey:@"bihua"];
            [songInfo setValue:lineArry[15] forKey:@"addtime"];
            [songInfo setValue:lineArry[16] forKey:@"spath"];
            
            if (reserveCount > maxSubMitCount) {
                if (acount>=maxSubMitCount) {
                    //submit
                    NSError *error;
                    [self.bgObjectContext save:&error];
                    reserveCount-=acount;
                    acount=0;
                }
            } else {
                if (reserveCount==acount) {
                    //submit
                    NSError *error;
                    [self.bgObjectContext save:&error];
                    reserveCount-=acount;
                    acount=0;
                }
            }
        }
     
    }

    [[NSUserDefaults standardUserDefaults]setObject:@YES forKey:@"SONGLISTIMPORTED"];
    txtPath=nil;
    fileHandle=nil;
    str=nil;
    lines=nil;
    if (handler) {
        handler(nil);
    }
    return nil;
}

- (NSError*)importDataForSingers:(OperationResult)handler {
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"SINGERLISTIMPORTED"]boolValue]) {
        if (handler) {
            handler(nil);
        }
        return nil;
    }
    NSString *txtPath=[[NSBundle mainBundle]pathForResource:@"singlist.txt" ofType:nil];
    NSFileHandle *fileHandle=[NSFileHandle fileHandleForReadingAtPath:txtPath];
    NSString *str=[[NSString alloc]initWithData:[fileHandle readDataToEndOfFile] encoding:NSUTF8StringEncoding];
    NSArray *lines=[str componentsSeparatedByString:@"\r\n"];
    long acount=0;
    long maxSubMitCount=20000;
    long reserveCount=lines.count;
    for (NSMutableString *tmplineStr in lines) {
        @autoreleasepool {
            acount++;
            NSMutableString *lineStr=[tmplineStr mutableCopy];
            [lineStr replaceOccurrencesOfString:@"\t\t" withString:@"\t" options:NSLiteralSearch range:NSMakeRange(0, lineStr.length)];
            NSArray *lineArry=[lineStr componentsSeparatedByString:@"\t"];
            if  (lineArry.count !=4) {
                NSError *error;
                [self.bgObjectContext save:&error];
                reserveCount-=acount;
                acount=0;
                continue;
            }
            
            NSManagedObject  *singersInfo=[NSEntityDescription insertNewObjectForEntityForName:@"Singer" inManagedObjectContext:self.bgObjectContext];
            [singersInfo setValue:lineArry[0] forKey:@"singer"];
            [singersInfo setValue:lineArry[1] forKey:@"pingyin"];
            [singersInfo setValue:lineArry[2] forKey:@"s_bi_hua"];
            [singersInfo setValue:lineArry[3] forKey:@"area"];
            
            if (reserveCount > maxSubMitCount) {
                if (acount>=maxSubMitCount) {
                    //submit
                    NSError *error;
                    [self.bgObjectContext save:&error];
                    reserveCount-=acount;
                    acount=0;
                }
            } else {
                if (reserveCount==acount) {
                    //submit
                    NSError *error;
                    [self.bgObjectContext save:&error];
                    reserveCount-=acount;
                    acount=0;
                }
            }
        }
    }
//    NSError *error;
//    [self.bgObjectContext save:&error];
    [[NSUserDefaults standardUserDefaults]setObject:@YES forKey:@"SINGERLISTIMPORTED"];
    txtPath=nil;
    fileHandle=nil;
    str=nil;
    lines=nil;
    if (handler) {
        handler(nil);
    }
    return nil;
    
}

- (NSError*)importDataForType:(OperationResult)handler {
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"SINGERTYPEIMPORTED"]boolValue]) {
        if (handler) {
            handler(nil);
        }
        return nil;
    }
    
    NSString *txtPath=[[NSBundle mainBundle]pathForResource:@"typelist.txt" ofType:nil];
    NSFileHandle *fileHandle=[NSFileHandle fileHandleForReadingAtPath:txtPath];
    NSString *str=[[NSString alloc]initWithData:[fileHandle readDataToEndOfFile] encoding:NSUTF8StringEncoding];
    NSArray *lines=[str componentsSeparatedByString:@"\r\n"];
    long acount=0;
    long maxSubMitCount=2000;
    long reserveCount=lines.count;
    for (NSMutableString *lineStr in lines) {
        @autoreleasepool {
            acount++;
            NSArray *lineArry=[lineStr componentsSeparatedByString:@"\t"];
            if  (lineArry.count !=3) {
                NSError *error;
                [self.bgObjectContext save:&error];
                reserveCount-=acount;
                acount=0;
                continue;
            };
            NSManagedObject  *typeInfo=[NSEntityDescription insertNewObjectForEntityForName:@"Typelist" inManagedObjectContext:self.bgObjectContext];
            [typeInfo setValue:lineArry[0] forKey:@"zztype"];
            [typeInfo setValue:lineArry[1] forKey:@"zztypeid"];
            [typeInfo setValue:lineArry[2] forKey:@"zztypename"];
            
            if (reserveCount > maxSubMitCount) {
                if (acount>=maxSubMitCount) {
                    //submit
                    NSError *error;
                    [self.bgObjectContext save:&error];
                    reserveCount-=acount;
                    acount=0;
                }
            } else {
                if (reserveCount==acount) {
                    //submit
                    NSError *error;
                    [self.bgObjectContext save:&error];
                    reserveCount-=acount;
                    acount=0;
                }
            }
        }
    }
//    NSError *error;
//    [self.bgObjectContext save:&error];
    [[NSUserDefaults standardUserDefaults]setObject:@YES forKey:@"SINGERTYPEIMPORTED"];
    txtPath=nil;
    fileHandle=nil;
    str=nil;
    lines=nil;
    if (handler) {
        handler(nil);
    }
    return nil;
}

- (void)queryData:(NSString*)name {
    NSEntityDescription *entity=[NSEntityDescription entityForName:name inManagedObjectContext:self.mainObjectContext];
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:entity];
    [request setFetchLimit:20];
    //    [request setFetchOffset:currentPage*10];
    //    NSArray *fetchedObjects =[self.managedObjectContext executeFetchRequest:request error:nil];
}


@end

