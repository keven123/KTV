//
//  YiDianViewController.m
//  KTV
//
//  Created by stevenhu on 15/4/26.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import "YiDianViewController.h"
#define TOPCELLIDENTIFY @"YiDianTopViewCell"
#import "YiDianTopViewCell.h"
#define BOTTOMCELLIDENTIFY @"SongBottomCell"
#import "SongBottomCell.h"
@interface YiDianViewController ()<SongListSongDelegate>
{
    NSInteger _previousRow;
    HuToast *myToast;

}
@property (nonatomic, strong) NSMutableArray *dataSrc;

@end

@implementation YiDianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"已点";
    _previousRow = -1;
    myToast=[[HuToast alloc]init];
    UINib *nib=[UINib nibWithNibName:TOPCELLIDENTIFY bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:TOPCELLIDENTIFY];
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.tableView.tableFooterView=backView;
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.showsVerticalScrollIndicator=NO;
    UIImageView *bgImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"songsList_bg"]];
    self.tableView.backgroundView=bgImageView;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;

    self.tableView.rowHeight=60.0f;
    self.dataSrc = [[NSMutableArray alloc] initWithObjects:@"R-000",@"R-001",@"R-002",@"R-003",@"R-004",@"R-000",@"R-001",@"R-002",@"R-003",@"R-004", nil];
    //toolbar
    UIBarButtonItem *flex0=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemFlexibleSpace) target:nil action:nil];
    UIBarButtonItem *kege=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"kege"] style:UIBarButtonItemStylePlain target:self action:@selector(clicked_kege:)];
    kege.tintColor=[UIColor whiteColor];
    
    UIBarButtonItem *flex1=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemFlexibleSpace) target:nil action:nil];
    UIBarButtonItem *bokong=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bokong"] style:UIBarButtonItemStylePlain target:self action:@selector(clicked_bokong:)];
    bokong.tintColor=[UIColor whiteColor];
    
    UIBarButtonItem *flex2=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemFlexibleSpace) target:nil action:nil];
    UIBarButtonItem *shenkong=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"shenkong"] style:UIBarButtonItemStylePlain target:self action:@selector(clicked_shenkong:)];
    shenkong.tintColor=[UIColor whiteColor];
    
    UIBarButtonItem *flex3=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemFlexibleSpace) target:nil action:nil];
    UIBarButtonItem *setting=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"setting"] style:UIBarButtonItemStylePlain target:self action:@selector(clicked_setting:)];
    setting.tintColor=[UIColor whiteColor];
    
    UIBarButtonItem *flex4=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemFlexibleSpace) target:nil action:nil];
    self.toolbarItems=@[flex0,kege,flex1,bokong,flex2,shenkong,flex3,setting,flex4];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.dataSrc.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YiDianTopViewCell *cell=(YiDianTopViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.opened=!cell.opened;
    if (cell.opened) {
        cell.sanjiaoxing.hidden=NO;
    } else {
        cell.sanjiaoxing.hidden=YES;
    }
    if (_previousRow >= 0) {
        NSIndexPath *preIndexPath=[NSIndexPath indexPathForRow:_previousRow inSection:0];
        YiDianTopViewCell *preCell=(YiDianTopViewCell*)[tableView cellForRowAtIndexPath:preIndexPath];
        
        if (indexPath.row == _previousRow + 1) {
            //            NSLog(@"fff");
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"insert is %ld=%ld:",_previousRow+1,indexPath.row);
    if (_previousRow >= 0 && _previousRow+1==indexPath.row) {
        SongBottomCell *cell=[tableView dequeueReusableCellWithIdentifier:BOTTOMCELLIDENTIFY];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:BOTTOMCELLIDENTIFY owner:self options:nil];
            cell = [nib objectAtIndex:0];
            cell.delegate=self;
            cell.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"song_bt_bg"]];
            
        }
        return cell;
    } else {
        YiDianTopViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TOPCELLIDENTIFY forIndexPath:indexPath];
        cell.songName.text=self.dataSrc[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


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


#pragma mark - SongBottom delegate
- (void)addCollectionSong:(Song *)oneSong result:(KMessageStyle)result {
    [myToast dissmiss];
    switch (result) {
        case KMessageSuccess: {
            NSIndexPath *indexPath=[NSIndexPath indexPathForItem:_previousRow inSection:0];
            YiDianTopViewCell *cell=(YiDianTopViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            cell.opened=!cell.opened;
            if (cell.opened) {
                cell.sanjiaoxing.hidden=NO;
            } else {
                cell.sanjiaoxing.hidden=YES;
            }
            [_dataSrc removeObjectAtIndex:_previousRow+1];
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
