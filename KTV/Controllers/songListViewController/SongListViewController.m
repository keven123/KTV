//
//  ViewController.m
//  Table
//
//  Created by ywx272253 on 15/4/24.
//  Copyright (c) 2015年 com.huawei.hwcloud. All rights reserved.
//

#import "SongListViewController.h"
#define TOPCELLIDENTIFY @"SongTopCell"
#import "SongTopCell.h"
#define BOTTOMCELLIDENTIFY @"SongBottomCell"
#import "SongBottomCell.h"
#import "YiDianViewController.h"
#import "Song.h"
#import "NSManagedObject+helper.h"
#import "BBBadgeBarButtonItem.h"
#import "SettingViewController.h"
#import "BokongView.h"
#import "SoundViewController.h"
#import "MBProgressHUD.h"
@interface SongListViewController ()<SongListSongDelegate>
{
    NSMutableArray *dataList;
    NSInteger _previousRow;
    HuToast *myToast;

}
@end

@implementation SongListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _previousRow = -1;
    myToast=[[HuToast alloc]init];
    self.title=@"歌曲";
    dataList=[[NSMutableArray alloc]init];
    UINib *nib=[UINib nibWithNibName:TOPCELLIDENTIFY bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:TOPCELLIDENTIFY];
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    UIImageView *bgImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"songsList_bg"]];
    self.tableView.backgroundView=bgImageView;
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.tableView.tableFooterView=backView;
    self.tableView.rowHeight=50;
    [self initNavigationItem];
    
    MBProgressHUD *hud=[[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:hud];
    hud.labelText=@"加载...";
    [hud showAnimated:YES whileExecutingBlock:^{
        [self initializeTableContent];
    } completionBlock:^{
        [hud removeFromSuperview];
    }];
}

- (void)viewWillAppear:(BOOL)animated  {
    [super viewWillAppear:animated];
    BBBadgeBarButtonItem *barButton = (BBBadgeBarButtonItem *)self.navigationItem.rightBarButtonItem;
    barButton.badgeValue=[Utility instanceShare].yidianBadge;
    [barButton registNofification];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    BBBadgeBarButtonItem *barButton = (BBBadgeBarButtonItem *)self.navigationItem.rightBarButtonItem;
    [barButton removeNotification];
}

- (void)dealloc {
    BBBadgeBarButtonItem *barButton = (BBBadgeBarButtonItem *)self.navigationItem.rightBarButtonItem;
    [barButton removeNotification];
}


- (void)initializeTableContent {
    [Song async:^id(NSManagedObjectContext *ctx, NSString *className) {
        NSFetchRequest *fetchRequest=[[NSFetchRequest alloc]initWithEntityName:@"Song"];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"singer==%@",_singerName]];
        NSSortDescriptor *sortDescriptor=[NSSortDescriptor sortDescriptorWithKey:@"songname" ascending:NO];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        NSError *error;
        NSArray *tmpArray = [ctx executeFetchRequest:fetchRequest error:&error];
        if (error) {
            return error;
        }else{
            return tmpArray;
        }
        
    } result:^(NSArray *result, NSError *error) {
        dataList = [result mutableCopy];
        [self.tableView reloadData];
    }];
}

- (void)setTableViewBackGroundImage:(UIImage*)image {
    UIImageView *bgImageView=[[UIImageView alloc]initWithImage:image];
    self.tableView.backgroundView=bgImageView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SongTopCell *cell=(SongTopCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (![cell isKindOfClass:[SongTopCell class]]) return;
    if (cell.opened) {
        cell.sanjiaoxing.hidden=NO;
    } else {
         cell.sanjiaoxing.hidden=YES;
    }
    if (_previousRow >= 0) {
        NSIndexPath *preIndexPath=[NSIndexPath indexPathForRow:_previousRow inSection:0];
        SongTopCell *preCell=(SongTopCell*)[tableView cellForRowAtIndexPath:preIndexPath];

        if (indexPath.row == _previousRow + 1) {
//            NSLog(@"fff");
        }
        else if (indexPath.row == _previousRow) {
            cell.opened=!cell.opened;
            if (cell.opened) {
                cell.sanjiaoxing.hidden=NO;
            } else {
                cell.sanjiaoxing.hidden=YES;
            }
            [dataList removeObjectAtIndex:_previousRow+1];
            [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_previousRow+1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            _previousRow = -1;
        }
        else if (indexPath.row < _previousRow) {
            if (preCell.opened) {
               preCell.sanjiaoxing.hidden=NO;
            } else {
                preCell.sanjiaoxing.hidden=YES;
            }
            
            [dataList removeObjectAtIndex:_previousRow+1];
            [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_previousRow+1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            _previousRow = indexPath.row;
            [dataList insertObject:@"增加的" atIndex:indexPath.row+1];
            [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row+1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
        }
        else {
            if (preCell.opened) {
                preCell.sanjiaoxing.hidden=NO;
            } else {
                preCell.sanjiaoxing.hidden=YES;
            }
            
            NSInteger oler=_previousRow;
            _previousRow = indexPath.row;
            [dataList insertObject:@"增加的" atIndex:indexPath.row+1];
            [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row+1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
            [dataList removeObjectAtIndex:oler+1];
            _previousRow -=1;
            [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:oler+1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    } else {
        _previousRow = indexPath.row;
        [dataList insertObject:@"增加的" atIndex:_previousRow+1];
        [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_previousRow+1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"insert is %ld=%ld:",_previousRow+1,indexPath.row);
    if (_previousRow >= 0 && _previousRow+1==indexPath.row) {
        SongBottomCell *cell=[tableView dequeueReusableCellWithIdentifier:BOTTOMCELLIDENTIFY];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:BOTTOMCELLIDENTIFY owner:self options:nil];
            cell = [nib objectAtIndex:0];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"song_bt_bg"]];
            cell.delegate=self;
            cell.oneSong=dataList[_previousRow];
            
        }
        return cell;
    } else {
        SongTopCell *cell = [tableView dequeueReusableCellWithIdentifier:TOPCELLIDENTIFY forIndexPath:indexPath];
        cell.numberStr.text =[NSString stringWithFormat:@"%02d",(int)indexPath.row+1];
        cell.numberStr.font=[UIFont fontWithName:@"DIN Condensed" size:22];
//        Song *oneSong=dataList[indexPath.row];
//        cell.songName.text=oneSong.songname;
        cell.oneSong=dataList[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.buttonitem=self.navigationItem.rightBarButtonItem;
        cell.backgroundColor=[UIColor clearColor];
        if (cell.opened) {
            cell.sanjiaoxing.hidden=NO;
        } else {
            cell.sanjiaoxing.hidden=YES;
        }

        return cell;
        
    }
    return nil;
}


- (void)clicked_kege:(id)sender {
    NSLog(@"clicked_kege");
    
}

- (void)clicked_bokong:(id)sender {
    NSLog(@"clicked_bokong");
}

- (void)clicked_shenkong:(id)sender {
    NSLog(@"clicked_shenkong");
}

- (void)clicked_setting:(id)sender {
    NSLog(@"clicked_setting");
    //    settingViewController *setVC=[[settingViewController alloc]init];
    //    [self.navigationController pushViewController:setVC animated:YES];
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }

    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }

    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

//navigationbar
- (void)initNavigationItem {
    //navigation item
    UIButton *rightbtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightbtn.frame=CGRectMake(0, 0, 25, 25);
    [rightbtn.titleLabel sizeToFit];
    [rightbtn setImage:[UIImage imageNamed:@"yidian"] forState:UIControlStateNormal];
    [rightbtn addTarget:self action:@selector(clicked_yidian:) forControlEvents:UIControlEventTouchUpInside];
    BBBadgeBarButtonItem *barButton=[[BBBadgeBarButtonItem alloc] initWithCustomUIButton:rightbtn];
    barButton.badgeValue =[Utility instanceShare].yidianBadge;
    self.navigationItem.rightBarButtonItem=barButton;
}

- (void)clicked_yidian:(id)sender {
    NSLog(@"Bar Button Item Pressed");
    BBBadgeBarButtonItem *barButton = (BBBadgeBarButtonItem *)self.navigationItem.rightBarButtonItem;
    [[Utility instanceShare]clearYidianToZero];
    // If you don't want to remove the badge when it's zero just set
    barButton.shouldHideBadgeAtZero = YES;
    // Next time zero should still be displayed
    
    // You can customize the badge further (color, font, background), check BBBadgeBarButtonItem.h ;)
    YiDianViewController *yidianVC=[[YiDianViewController alloc]init];
    [self.navigationController pushViewController:yidianVC animated:YES];
}

// Fake adding element
- (IBAction)addItemToListButtonPressed {
    BBBadgeBarButtonItem *barButton = (BBBadgeBarButtonItem *)self.navigationItem.leftBarButtonItem;
    barButton.badgeValue = [NSString stringWithFormat:@"%d", [barButton.badgeValue intValue] + 1];
}


#pragma mark - SongBottom delegate
- (void)addCollectionSong:(Song *)oneSong result:(KMessageStyle)result {
    [myToast dissmiss];
    switch (result) {
        case KMessageSuccess: {
            NSIndexPath *indexPath=[NSIndexPath indexPathForItem:_previousRow inSection:0];
            SongTopCell *cell=(SongTopCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            cell.opened=!cell.opened;
            if (cell.opened) {
                cell.sanjiaoxing.hidden=NO;
            } else {
                cell.sanjiaoxing.hidden=YES;
            }
            [dataList removeObjectAtIndex:_previousRow+1];
            [self.tableView  deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_previousRow+1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            _previousRow=-1;
            [myToast setToastWithMessage:@"成功收藏"  WithTimeDismiss:nil messageType:KMessageSuccess];
            break;
        }
        case KMessageStyleError: {
            [myToast setToastWithMessage:@"收藏出错了,请重发"  WithTimeDismiss:nil messageType:KMessageStyleError];
            
            break;
        }
        case KMessageWarning: {
            [myToast setToastWithMessage:@"查询收藏出错了,请重发"  WithTimeDismiss:nil messageType:KMessageStyleError];
            
            break;
        }
        case KMessageStyleInfo: {
            [myToast setToastWithMessage:@"此歌已收藏"  WithTimeDismiss:nil messageType:KMessageStyleInfo];
            
            break;
        }
        case KMessageStyleDefault: {
            break;
        }
        default:
            break;
    }
    
}

- (void)dingGeFromCollection:(Song *)oneSong result:(KMessageStyle)result {
    //ding ge
    [myToast dissmiss];
    [myToast setToastWithMessage:@"顶歌成功" WithTimeDismiss:nil messageType:KMessageSuccess];
    //TODO::
}

- (void)cutSongFromCollection:(Song *)oneSong result:(KMessageStyle)result {
    [myToast dissmiss];
    [myToast setToastWithMessage:@"切歌成功" WithTimeDismiss:nil messageType:KMessageSuccess];
    //TODO::
    
    //cut song
}

#pragma mark -#########################################################

@end
