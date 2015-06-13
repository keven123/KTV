//
//  soundView.m
//  KTV
//
//  Created by stevenhu on 15/5/2.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import "soundView.h"
#import "Utility.h"
#import "UIImage+Resize.h"
@interface soundView () {
    UIButton *exitBtn;
    
    
    //three chuckview
    CGSize totoalSize;
    
    
    UIView *topChunckView;
    UIView *centerChunckView;
    UIView *bottomChunckView;
    
    //top
    UIStepper *micSteper;
    UIStepper *musicSteper;

//    jiajian
    UIImageView *playStopImageV;
    UIButton *playBtn;
    UIButton *stopbtn;
    iphoneModel myModel;
    
    
    //center
    UIButton *heCaiBtn;
    UIButton *daoCaiBtn;
    UIButton *mingLingBtn;
    UIButton *rouHeBtn;
    UIButton *dongGanBtn;
    UIButton *kaiGuangBtn;
    UIButton *serviceBtn;
    
    //bottm
//    UITextField *sendInput;
    
}

@end

@implementation soundView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (id)initWithFrame:(CGRect)frame   {
    if (self=[super initWithFrame:frame]) {
        myModel=[Utility whatIphoneDevice];
        self.backgroundColor=[UIColor groupTableViewBackgroundColor];
        totoalSize=self.bounds.size;
        self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"songsList_bg"]];
        [self createChunckViews];
    }
    return self;
}

//create chunck
- (void)createChunckViews {
    //topchunck
    topChunckView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,totoalSize.width, totoalSize.height/2)];
        topChunckView.backgroundColor=[UIColor clearColor];
//    topChunckView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"paly_song_bg"]];
    [self addSubview:topChunckView];
    //centerchunck
    centerChunckView=[[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(topChunckView.frame), totoalSize.width,topChunckView.bounds.size.height-44)];
//        centerChunckView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"paly_song_bg"]];
         centerChunckView.backgroundColor=[UIColor clearColor];
    [self addSubview:centerChunckView];
    
    bottomChunckView=[[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(centerChunckView.frame), totoalSize.width,44)];
//        bottomChunckView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"paly_song_bg"]];
           bottomChunckView.backgroundColor=[UIColor clearColor];
    [self createViewsForAllChuncks];
    [self addSubview:bottomChunckView];
    
}

//create up

- (void)createViewsForAllChuncks {
    
    exitBtn=[[UIButton alloc]init];
    micSteper=[[UIStepper alloc]init];
    musicSteper=[[UIStepper alloc]init];
    playStopImageV=[[UIImageView alloc]init];
    playBtn=[[UIButton alloc]init];
    stopbtn=[[UIButton alloc]init];
    CGSize topChuckSize=topChunckView.bounds.size;
    CGSize centerChuckSize=centerChunckView.bounds.size;
    //    CGSize bottomChuckSize=bottomChunckView.bounds.size;
    
    heCaiBtn=[[UIButton alloc]init];
    daoCaiBtn=[[UIButton alloc]init];
    mingLingBtn=[[UIButton alloc]init];
    rouHeBtn=[[UIButton alloc]init];
    dongGanBtn=[[UIButton alloc]init];
    kaiGuangBtn=[[UIButton alloc]init];
    serviceBtn=[[UIButton alloc]init];
    
    //    NSLog(@"%@",NSStringFromCGRect(micSteper.frame));
//    exitBtn.frame=CGRectMake(topChuckSize.width-50, 10, 40, 40);
//    [exitBtn setTitle:@"exit" forState:UIControlStateNormal];
//    [exitBtn addTarget:self action:@selector(exitShenKong:) forControlEvents:UIControlEventTouchUpInside];
//    [topChunckView addSubview:exitBtn];
    
    micSteper.frame=CGRectMake((topChuckSize.width/3-94)/2, topChuckSize.height/2-20,0, 0);
    micSteper.tintColor=[UIColor whiteColor];

      //imageview
    float ImageViewmaxWidth=MIN(topChuckSize.height, topChuckSize.width/3);
    
    playStopImageV.frame=CGRectMake(topChuckSize.width/3+(topChuckSize.width/3-(ImageViewmaxWidth-15))/2, topChuckSize.height/2-ImageViewmaxWidth/2, ImageViewmaxWidth-15,ImageViewmaxWidth-15);
    playStopImageV.image=[UIImage imageNamed:@"stopstart"];
    
    musicSteper.frame=CGRectMake(topChuckSize.width/3*2+(topChuckSize.width/3-94)/2, topChuckSize.height/2-20, 0,0);
    musicSteper.tintColor=[UIColor whiteColor];

    
    UILabel *micLabel=[[UILabel alloc]initWithFrame:CGRectMake(micSteper.frame.origin.x, CGRectGetMaxY(playStopImageV.frame), micSteper.bounds.size.width, micSteper.bounds.size.height)];
    micLabel.text=@"麦克风";
    micLabel.textAlignment=NSTextAlignmentCenter;
    micLabel.textColor=[UIColor groupTableViewBackgroundColor];
    
    UILabel *muteLabel=[[UILabel alloc]initWithFrame:CGRectMake(playStopImageV.frame.origin.x, CGRectGetMaxY(playStopImageV.frame), playStopImageV.bounds.size.width, micSteper.bounds.size.height)];
    muteLabel.text=@"静音/正常";
    muteLabel.textAlignment=NSTextAlignmentCenter;
    muteLabel.textColor=[UIColor groupTableViewBackgroundColor];
    
    UILabel *musicLabel=[[UILabel alloc]initWithFrame:CGRectMake(musicSteper.frame.origin.x, CGRectGetMaxY(playStopImageV.frame), musicSteper.bounds.size.width, musicSteper.bounds.size.height)];
    musicLabel.text=@"音乐";
    musicLabel.textAlignment=NSTextAlignmentCenter;
    musicLabel.textColor=[UIColor groupTableViewBackgroundColor];
    
    [topChunckView addSubview:micLabel];
    [topChunckView addSubview:muteLabel];
    [topChunckView addSubview:musicLabel];
    
    //center
    float btnMaxWidth=MIN(centerChuckSize.height/2, centerChuckSize.width/4-15);
    NSLog(@"%f",btnMaxWidth);
    heCaiBtn.frame=CGRectMake(16, 10, btnMaxWidth, btnMaxWidth);
    [heCaiBtn setImage:[UIImage imageNamed:@"hecai"] forState:UIControlStateNormal];
    [centerChunckView addSubview:heCaiBtn];
    
    daoCaiBtn.frame=CGRectMake(CGRectGetMaxX(heCaiBtn.frame)+10, CGRectGetMinY(heCaiBtn.frame), btnMaxWidth, btnMaxWidth);
    [daoCaiBtn setImage:[UIImage imageNamed:@"daocai"] forState:UIControlStateNormal];
    [centerChunckView addSubview:daoCaiBtn];
    
    rouHeBtn.frame=CGRectMake(CGRectGetMaxX(daoCaiBtn.frame)+10, CGRectGetMinY(heCaiBtn.frame), btnMaxWidth, btnMaxWidth);
    [rouHeBtn setImage:[UIImage imageNamed:@"rouhe"] forState:UIControlStateNormal];
    [centerChunckView addSubview:rouHeBtn];
    
    mingLingBtn.frame=CGRectMake(CGRectGetMaxX(rouHeBtn.frame)+10, CGRectGetMinY(heCaiBtn.frame), btnMaxWidth, btnMaxWidth);
    [mingLingBtn setImage:[UIImage imageNamed:@"mingliang"] forState:UIControlStateNormal];
    [centerChunckView addSubview:mingLingBtn];
    
    dongGanBtn.frame=CGRectMake(CGRectGetMinX(heCaiBtn.frame), CGRectGetMaxY(heCaiBtn.frame)+10, btnMaxWidth, btnMaxWidth);
    [dongGanBtn setImage:[UIImage imageNamed:@"donggang"] forState:UIControlStateNormal];
    [centerChunckView addSubview:dongGanBtn];
    
    kaiGuangBtn.frame=CGRectMake(CGRectGetMaxX(dongGanBtn.frame)+10, CGRectGetMinY(dongGanBtn.frame), btnMaxWidth, btnMaxWidth);
    [kaiGuangBtn setImage:[UIImage imageNamed:@"gaiguang"] forState:UIControlStateNormal];
    [centerChunckView addSubview:kaiGuangBtn];
    
    serviceBtn.frame=CGRectMake(CGRectGetMaxX(kaiGuangBtn.frame)+40, CGRectGetMinY(dongGanBtn.frame), btnMaxWidth*1.5, btnMaxWidth);
    [serviceBtn setImage:[UIImage imageNamed:@"fuwu"] forState:UIControlStateNormal];
    [centerChunckView addSubview:serviceBtn];
    

    [topChunckView addSubview:micSteper];
    [topChunckView addSubview:musicSteper];

    [topChunckView addSubview:playStopImageV];
    [centerChunckView addSubview:heCaiBtn];
    [centerChunckView addSubview:daoCaiBtn];
    [centerChunckView addSubview:rouHeBtn];
    [centerChunckView addSubview:mingLingBtn];
    [centerChunckView addSubview:dongGanBtn];
    [centerChunckView addSubview:kaiGuangBtn];
    [centerChunckView addSubview:serviceBtn];
    
    
}


- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(void)exitShenKong:(id)sender {
    if ([self.delegate respondsToSelector:@selector(exitShengKongView)]) {
        [self.delegate exitShengKongView];
    }
}

@end
