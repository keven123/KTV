//
//  AppDelegate.m
//  KTV
//
//  Created by stevenhu on 15/4/17.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import "AppDelegate.h"
#import "UINavigationBar+customBar.h"
#import "MainViewController.h"
#import "SoundViewController.h"
#import "SettingViewController.h"
#import "BokongView.h"
#import "NmainViewController.h"
#import "UIImage+Resize.h"
#import "DownLoadOperation.h"
#define Vedio @"http://221.228.249.82/youku/697A5CA0CEB3582FB91C4E3A88/03002001004E644FA2997704E9D2A7BA1E7B9D-6CAB-79A9-E635-3B92A92B3500.mp4"
#define Picture @"http://x1.zhuti.com/down/2012/11/29-win7/3D-1.jpg"

@interface AppDelegate ()<BokongDelegate> {
    int currentItem;
    DownLoadOperation* operation;

}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //    _rootNavC=[[UINavigationController alloc]initWithRootViewController:_window.rootViewController];
    //    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPageCurl target:nil action:nil];
    //    [_rootNavC.navigationItem setBackBarButtonItem:backItem];
    //    UIImage *image=[[UIImage imageNamed:@"new_nav_bg"]stretchableImageWithLeftCapWidth:10 topCapHeight:30];
    //    [_rootNavC.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    //    [_rootNavC.toolbar setBackgroundImage:image forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    //    NSDictionary * navBarTitleTextAttributes =@{ NSForegroundColorAttributeName : [UIColor whiteColor]};
    //    [[UINavigationBar appearance] setTitleTextAttributes:navBarTitleTextAttributes];
    //    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
    //    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];
    //    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
    //                                                       [UIColor whiteColor], NSForegroundColorAttributeName,
    //                                                       nil] forState:UIControlStateNormal];
    //    UIColor *titleHighlightedColor = [UIColor greenColor];
    //    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
    //                                                       titleHighlightedColor, NSForegroundColorAttributeName,
    //                                                       nil] forState:UIControlStateSelected];
    //    self.window.rootViewController=_rootNavC;
    [self downLoadFiles];
    //    operation = [[DownLoadOperation alloc] init];
    //    [operation sendCmd];
    UITabBarController *tabVC=[[UITabBarController alloc]init];
    tabVC.delegate=self;
    
    UIImage *imagebottom=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"nav_bottom_bg" ofType:@"png"]];
    UIImage *imagetop=[[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"song_bt_bg" ofType:@"png"]]stretchableImageWithLeftCapWidth:0 topCapHeight:30];
    
    [tabVC.tabBar setBackgroundImage:imagebottom];
    NSDictionary * navBarTitleTextAttributes =@{ NSForegroundColorAttributeName : [UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:navBarTitleTextAttributes];
    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
    
    UINavigationController *navC1=[[UINavigationController alloc]initWithRootViewController:[[MainViewController alloc]init]];
    //      UINavigationController *navC1=[[UINavigationController alloc]initWithRootViewController:[[NmainViewController alloc]init]];
    
    [navC1.navigationBar setBackgroundImage:imagetop forBarMetrics:UIBarMetricsDefault];
    
    //    UINavigationController *navC2=[[UINavigationController alloc]initWithRootViewController:[[UIViewController alloc]init]];
    //    [navC2.navigationBar setBackgroundImage:imagetop forBarMetrics:UIBarMetricsDefault];
    
    UINavigationController *navC3=[[UINavigationController alloc]initWithRootViewController:[[SoundViewController alloc]init]];
    [navC3.navigationBar setBackgroundImage:imagetop forBarMetrics:UIBarMetricsDefault];
    UINavigationController *navC4=[[UINavigationController alloc]initWithRootViewController:[[SettingViewController alloc]init]];
    [navC4.navigationBar setBackgroundImage:imagetop forBarMetrics:UIBarMetricsDefault];
    //    tabVC.viewControllers=@[navC1,navC2,navC3,navC4];
    tabVC.viewControllers=@[navC1,navC3,navC4];
    //设置标题
    
    //    navC1.title = @"k歌";
    //    navC2.title = @"播控";
    //    navC3.title = @"声控";
    //    navC4.title = @"设置";
    
    //kfq
    navC1.title = @"k歌";
    navC3.title = @"播音";
    navC4.title = @"设置";
    
    //
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor whiteColor], NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateNormal];
    UIColor *titleHighlightedColor = [UIColor orangeColor];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor, NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateSelected];
    
    //设置图片
    navC1.tabBarItem.image = [[UIImage imageNamed:@"kege"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navC1.tabBarItem.selectedImage=[[UIImage imageNamed:@"kege_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    //    navC2.tabBarItem.image = [[UIImage imageNamed:@"bokong"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //     navC2.tabBarItem.selectedImage = [[UIImage imageNamed:@"bokong_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    navC3.tabBarItem.image = [[UIImage imageNamed:@"shenkong"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navC3.tabBarItem.selectedImage = [[UIImage imageNamed:@"shenkong_seleted"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    navC4.tabBarItem.image = [[UIImage imageNamed:@"setting"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navC4.tabBarItem.selectedImage = [[UIImage imageNamed:@"setting_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    currentItem=0;
    self.window.rootViewController=tabVC;
    return YES;
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
//    if (tabBarController.selectedIndex==1) {
//        tabBarController.selectedIndex=currentItem;
//        BokongView *view= [BokongView instanceShare];
//        view.delegate=self;
//        [view showAtView:nil];
//    } else {
//        currentItem=(int)tabBarController.selectedIndex;
//    }
    
    if (tabBarController.selectedIndex==1) {
        //        tabBarController.selectedIndex=currentItem;
        BokongView *view= [BokongView instanceShare];
        view.delegate=self;
        [view showAtView:nil];
    } else {
        currentItem=(int)tabBarController.selectedIndex;
    }
    
    //kfq
    currentItem=(int)tabBarController.selectedIndex;
}

- (void)boKongHadDimssed {
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//
//- (void)batchImportData {
//    BOOL value=[[NSUserDefaults standardUserDefaults]objectForKey:@"DATAIMPORTED"];
//    if (!value) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//            [self importDataForSongs];
//            [self importDataForSingers];
//            [self importDataForType];
//            [[NSUserDefaults standardUserDefaults]setObject:@YES forKey:@"DATAIMPORTED"];
//        });
//    }
//}
//
//- (void)importDataForSongs {
//    NSString *txtPath=[[NSBundle mainBundle]pathForResource:@"songlist.txt" ofType:nil];
//    NSFileHandle *fileHandle=[NSFileHandle fileHandleForReadingAtPath:txtPath];
//    NSString *str=[[NSString alloc]initWithData:[fileHandle readDataToEndOfFile] encoding:NSUTF8StringEncoding];
//    NSArray *lines=[str componentsSeparatedByString:@"\t\r\n"];
//    for (NSString *lineStr in lines) {
//        NSArray *lineArry=[lineStr componentsSeparatedByString:@"\t"];
//        if  (lineArry.count !=17) continue;
//        Song *oneSong=[Song createNew];
//        oneSong.number=lineArry[0];
//        oneSong.songname=lineArry[1];
//        oneSong.singer=lineArry[2];
//        oneSong.singer1=lineArry[3];
//        oneSong.songpiy=lineArry[4];
//        oneSong.word=lineArry[5];
//        oneSong.language=lineArry[6];
//        oneSong.volume=lineArry[7];
//        oneSong.channel=lineArry[8];
//        oneSong.sex=lineArry[9];
//        oneSong.stype=lineArry[10];
//        oneSong.newsong=lineArry[11];
//        oneSong.movie=lineArry[12];
//        oneSong.pathid=lineArry[13];
//        oneSong.bihua=lineArry[14];
//        oneSong.addtime=lineArry[15];
//        oneSong.spath=lineArry[16];
//        [Song save:nil];
//    }
//}
//
//- (void)importDataForSingers {
//    
//    NSString *txtPath=[[NSBundle mainBundle]pathForResource:@"singlist.txt" ofType:nil];
//    NSFileHandle *fileHandle=[NSFileHandle fileHandleForReadingAtPath:txtPath];
//    NSString *str=[[NSString alloc]initWithData:[fileHandle readDataToEndOfFile] encoding:NSUTF8StringEncoding];
//    NSArray *lines=[str componentsSeparatedByString:@"\r\n"];
//    for (NSMutableString *tmplineStr in lines) {
//        NSMutableString *lineStr=[tmplineStr mutableCopy];
//        [lineStr replaceOccurrencesOfString:@"\t\t" withString:@"\t" options:NSLiteralSearch range:NSMakeRange(0, lineStr.length)];
//        NSArray *lineArry=[lineStr componentsSeparatedByString:@"\t"];
//        if  (lineArry.count !=4) continue;
//        Singer *oneSinger=[Singer createNew];
//        oneSinger.singer=lineArry[0];
//        oneSinger.pingyin=lineArry[1];
//        oneSinger.s_bi_hua=lineArry[2];
//        oneSinger.area=lineArry[3];
//        [Singer save:nil];
//    }
//    
//}
//
//- (void)importDataForType {
//    NSString *txtPath=[[NSBundle mainBundle]pathForResource:@"typelist.txt" ofType:nil];
//    NSFileHandle *fileHandle=[NSFileHandle fileHandleForReadingAtPath:txtPath];
//    NSString *str=[[NSString alloc]initWithData:[fileHandle readDataToEndOfFile] encoding:NSUTF8StringEncoding];
//    NSArray *lines=[str componentsSeparatedByString:@"\r\n"];
//    for (NSMutableString *lineStr in lines) {
//        NSArray *lineArry=[lineStr componentsSeparatedByString:@"\t"];
//        if  (lineArry.count !=3) continue;
//        Typelist *typeList=[Typelist createNew];
//        typeList.type=lineArry[0];
//        typeList.typeid=lineArry[1];
//        typeList.typename=lineArry[2];
//        [Typelist save:nil];
//    }
//    
//}

- (void)downLoadFiles {
    NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/temp"];
    NSLog(@"path = %@",path);
    operation = [[DownLoadOperation alloc] init];
    [operation downloadFileWithFileName:@"songlist.txt"
                     cachePath:^NSString *{
                         return path;
                     } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
                         
                         NSLog(@"bytesRead = %u ,totalBytesRead = %llu totalBytesExpectedToRead = %llu",bytesRead,totalBytesRead,totalBytesExpectedToRead);
                         float progress = totalBytesRead / (float)totalBytesExpectedToRead;
                         
//                         [self.progressView setProgress:progress animated:YES];
                         
//                         [self.label setText:[NSString stringWithFormat:@"%.2f%%",progress*100]];
                         UIImage* image = [UIImage imageWithData:operation.requestOperation.responseData];
//                         [self.imageView setImage:image];
                         
                     } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         
                         NSLog(@"success");
//                         UIImage* image = [UIImage imageWithData:operation.responseData];
//                         [self.imageView setImage:image];
                         
                         
                         
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         NSLog(@"error = %@",error);
                     }];

}
@end
