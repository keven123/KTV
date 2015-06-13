//
//  paiHangViewController.m
//  KTV
//
//  Created by stevenhu on 15/4/25.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import "paiHangViewController.h"
#import "paiHangViewCell.h"
#define CELLIDENTIFY @"paiHangViewCell"
#define BOTTOMCELLIDENTIFY @"SongBottomCell"
#import "SongBottomCell.h"
#import "YiDianViewController.h"
#import "BBBadgeBarButtonItem.h"
#import "Utility.h"
#import "SoundViewController.h"
#import "BokongView.h"
#import "SettingViewController.h"
@interface paiHangViewController ()
{
    NSInteger _previousRow;
    
}
@property(nonatomic,strong)NSMutableArray *dataSrc;
@end

@implementation paiHangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"排行榜";
    _previousRow = -1;
    UINib *nib=[UINib nibWithNibName:CELLIDENTIFY bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CELLIDENTIFY];
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.tableView.tableFooterView=backView;
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    UIImageView *bgImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"geshou_area_bg"]];
    self.tableView.backgroundView=bgImageView;
    self.tableView.rowHeight=50;
    self.dataSrc = [[NSMutableArray alloc] initWithObjects:@"R-000",@"R-001",@"R-002",@"R-003",@"R-004",@"R-000",@"R-001",@"R-002",@"R-003",@"R-004", nil];
    [self initNavigationItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.dataSrc.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    NSLog(@"insert is %ld=%ld:",_previousRow+1,indexPath.row);
    if (_previousRow >= 0 && _previousRow+1==indexPath.row) {
        SongBottomCell *cell=[tableView dequeueReusableCellWithIdentifier:BOTTOMCELLIDENTIFY];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:BOTTOMCELLIDENTIFY owner:self options:nil];
            cell = [nib objectAtIndex:0];
            cell.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"song_bt_bg"]];
#warning             cell.oneSong=self.dataList[_previousRow];

        }
        return cell;
    } else {
//        paihang_flag0
        paiHangViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDENTIFY forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;   
        cell.numberStr.text =[NSString stringWithFormat:@"%02d",(int)indexPath.row+1];
        cell.numberStr.font=[UIFont fontWithName:@"DIN Condensed" size:18];
        cell.songName.font=[UIFont systemFontOfSize:15];
        cell.singer.font=[UIFont systemFontOfSize:12];
        cell.buttonitem=self.navigationItem.rightBarButtonItem;
        cell.backgroundColor=[UIColor clearColor];
        cell.paihangFlagView.image=[UIImage imageNamed:[NSString stringWithFormat:@"paihang_flag%d",(int)(indexPath.row+7)%7]];
        if (cell.opened) {
            cell.sanjiaoxing.hidden=NO;
        } else {
            cell.sanjiaoxing.hidden=YES;
        }
        return cell;
    }
    return nil;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    paiHangViewCell *cell=(paiHangViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.opened=!cell.opened;
    if (cell.opened) {
        cell.sanjiaoxing.hidden=NO;
    } else {
        cell.sanjiaoxing.hidden=YES;
    }
    if (_previousRow >= 0) {
        NSIndexPath *preIndexPath=[NSIndexPath indexPathForRow:_previousRow inSection:0];
        paiHangViewCell *preCell=(paiHangViewCell*)[tableView cellForRowAtIndexPath:preIndexPath];
        
        if (indexPath.row == _previousRow + 1) {
            NSLog(@"fff");
        }
        else if (indexPath.row == _previousRow) {
            
            [self.dataSrc removeObjectAtIndex:_previousRow+1];
            [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_previousRow+1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            _previousRow = -1;
        }
        else if (indexPath.row < _previousRow) {
            preCell.opened=!preCell.opened;
            if (preCell.opened) {
                preCell.sanjiaoxing.hidden=NO;
            } else {
                preCell.sanjiaoxing.hidden=YES;
            }
            
            [self.dataSrc removeObjectAtIndex:_previousRow+1];
            [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_previousRow+1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            _previousRow = indexPath.row;
            [self.dataSrc insertObject:@"增加的" atIndex:indexPath.row+1];
            [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row+1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
        }
        else {
            preCell.opened=!preCell.opened;
            if (preCell.opened) {
                preCell.sanjiaoxing.hidden=NO;
            } else {
                preCell.sanjiaoxing.hidden=YES;
            }
            
            NSInteger oler=_previousRow;
            _previousRow = indexPath.row;
            [self.dataSrc insertObject:@"增加的" atIndex:indexPath.row+1];
            [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row+1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
            [self.dataSrc removeObjectAtIndex:oler+1];
            _previousRow -=1;
            [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:oler+1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    } else {
        _previousRow = indexPath.row;
        [self.dataSrc insertObject:@"增加的" atIndex:_previousRow+1];
        [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_previousRow+1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
    }
    
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


- (void)clicked_kege:(id)sender {
    NSLog(@"clicked_kege");
}

- (void)clicked_bokong:(id)sender {
    NSLog(@"clicked_bokong");
    [[BokongView instanceShare]showAtView:[(UIBarButtonItem*)sender customView]];
}


- (void)clicked_shenkong:(id)sender {
    NSLog(@"clicked_shenkong");
    SoundViewController *vc=[[SoundViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)clicked_setting:(id)sender {
    NSLog(@"clicked_setting");
    SettingViewController *setVC=[[SettingViewController alloc]init];
    [self.navigationController pushViewController:setVC animated:YES];
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

@end
