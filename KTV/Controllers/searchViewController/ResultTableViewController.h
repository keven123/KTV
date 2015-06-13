//
//  ResultTableViewController.h
//  ZZKTV
//
//  Created by stevenhu on 15/3/30.
//  Copyright (c) 2015年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol searchSongDelegate <NSObject>
- (void)searching;
- (void)searchDone;
@end

@interface ResultTableViewController : UITableViewController<UISearchResultsUpdating,UISearchBarDelegate>
@property (nonatomic,weak) id<searchSongDelegate>delegate;
@end
