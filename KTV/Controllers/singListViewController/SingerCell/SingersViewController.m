//
//  SingsViewController.m
//  KTV
//
//  Created by stevenhu on 15/4/21.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import "SingersViewController.h"
#import "SingerAreaTypeCell.h"
#import "SongListViewController.h"
#import "Singer.h"
#import "NSManagedObject+helper.h"
#define CELLIDENTIFY @"SingerAreaTypeCell"
#import "YiDianViewController.h"
#import "BBBadgeBarButtonItem.h"
#import "BokongView.h"
#import "SettingViewController.h"
#import "SoundViewController.h"
#import "MBProgressHUD.h"
@interface SingersViewController () {
    NSArray *dataList;
}
@property(nonatomic,strong)NSArray *indexArray;
@end

@implementation SingersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"歌手";
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    UINib *nib=[UINib nibWithNibName:@"SingerAreaTypeCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CELLIDENTIFY];
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.tableView.tableFooterView=backView;
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.showsVerticalScrollIndicator=NO;
    UIImageView *bgImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"songsList_bg"]];
    self.tableView.backgroundView=bgImageView;
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

- (void)initializeTableContent {
    [Singer async:^id(NSManagedObjectContext *ctx, NSString *className) {
        NSFetchRequest *fetchRequest=[[NSFetchRequest alloc]initWithEntityName:@"Singer"];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"area==%@",_area]];
        NSSortDescriptor *sortDescriptor=[NSSortDescriptor sortDescriptorWithKey:@"singer" ascending:NO];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        NSError *error;
        NSArray *tmpArray = [ctx executeFetchRequest:fetchRequest error:&error];
        if (error) {
            return error;
        }else{
            return tmpArray;
        }
        
    } result:^(NSArray *result, NSError *error) {
        dataList = result;
        [self.tableView reloadData];
    }];
}


- (void)viewWillAppear:(BOOL)animated  {
    [super viewWillAppear:animated];
    BBBadgeBarButtonItem *barButton = (BBBadgeBarButtonItem *)self.navigationItem.rightBarButtonItem;
    barButton.badgeValue =[Utility instanceShare].yidianBadge;
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    BBBadgeBarButtonItem *barButton = (BBBadgeBarButtonItem *)self.navigationItem.rightBarButtonItem;
    barButton.badgeValue =[Utility instanceShare].yidianBadge;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SingerAreaTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDENTIFY forIndexPath:indexPath];
    [cell.headImageV setImage:[UIImage imageNamed:@"kge_head"]];
    Singer *oneSinger=dataList[indexPath.row];
    cell.SingerLabel.text=oneSinger.singer;
    cell.SingerLabel.textColor=[UIColor groupTableViewBackgroundColor];
    cell.SingerLabel.font=[UIFont systemFontOfSize:14];
    cell.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"geshou_area_cell_bg"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SongListViewController *vc=[[SongListViewController alloc]init];
    Singer *oneSinger=dataList[indexPath.row];
    vc.singerName=oneSinger.singer;
   [self.navigationController pushViewController:vc animated:YES];
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
    barButton.badgeValue =[Utility instanceShare].yidianBadge=@"0";
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
