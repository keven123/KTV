//
//  SingerViewController.m
//  KTV
//
//  Created by stevenhu on 15/4/19.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import "SingerAreaViewController.h"
#import "SingerAreaTypeCell.h"
#define CELLIDENTIFY @"SingerAreaTypeCell"
#import "Typelist.h"
#import "SingersViewController.h"
#import "NSManagedObject+helper.h"
#import "newSongViewController.h"
#import "YiDianViewController.h"
#import "BBBadgeBarButtonItem.h"
#import "BokongView.h"
#import "SettingViewController.h"
#import "SoundViewController.h"
#import "MBProgressHUD.h"
@interface SingerAreaViewController ()<UITableViewDataSource,UITableViewDelegate> {
    NSArray *dataList;
}

@end

@implementation SingerAreaViewController
    - (void)viewDidLoad {
    [super viewDidLoad];
   self.title=@"区域";
    UINib *nib=[UINib nibWithNibName:@"SingerAreaTypeCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CELLIDENTIFY];
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.tableView.tableFooterView=backView;
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        self.tableView.separatorColor=[UIColor colorWithRed:100 green:27 blue:55 alpha:1];
    UIImageView *bgImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"songsList_bg"]];
    self.tableView.backgroundView=bgImageView;
    self.tableView.rowHeight=80;
    //navigation bar
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
    [Typelist async:^id(NSManagedObjectContext *ctx, NSString *className) {
        NSFetchRequest *fetchRequest=[[NSFetchRequest alloc]initWithEntityName:@"Typelist"];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"zztype==%d",_zztype]];
        NSSortDescriptor *sortDescriptor=[NSSortDescriptor sortDescriptorWithKey:@"zztypename" ascending:NO];
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

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  dataList.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SingerAreaTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDENTIFY forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.headImageV setImage:[UIImage imageNamed:@"kge_head"]];
    Typelist *onetype=dataList[indexPath.row];
    cell.SingerLabel.text=onetype.zztypename;
    cell.SingerLabel.textColor=[UIColor groupTableViewBackgroundColor];
    cell.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"geshou_area_cell_bg"]];
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        SingersViewController *vc=[[SingersViewController alloc]init];
        Typelist *onetype=dataList[indexPath.row];
        vc.area=onetype.zztype;
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
