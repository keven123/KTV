//
//  songListViewController.h
//  zzKTV
//
//  Created by mCloud on 15/3/30.
//  Copyright (c) 2015年 StevenHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchSongListViewController : UITableViewController
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (void)showPromtView:(BOOL)isShow;
@end
