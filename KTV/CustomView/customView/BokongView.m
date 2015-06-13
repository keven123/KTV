//
//  BokongView.m
//  KTV
//
//  Created by stevenhu on 15/4/27.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#define SCREEN_SIZE  [UIScreen mainScreen].bounds.size
#define WINDOW  [UIApplication sharedApplication].keyWindow
#define BOKONG_WIDTH (SCREEN_SIZE.width-20)
#define BOKONG_HEIGHT 140
#define BOKONG_SPACE 15
#define LABEL_HEIGHT 20
#import "BokongView.h"

@interface BokongView(){
    UIView *chuckView;
    UIImageView *bokong;
    float bokongViewHeight;
    BOOL isShow;
}

@end
static BokongView *shareInstance=nil;
@implementation BokongView

+(instancetype)instanceShare {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!shareInstance) {
            shareInstance=[[self alloc]init];
        }
    });
    return shareInstance;

}



+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance=[super allocWithZone:zone];
    });
    return shareInstance;
}




- (void)showAtView:(UIView*)view {
    
    if (isShow) {
        [self disMiss];
    } else {
        [self createViews];
        [self showView];
       
    }
}

- (void)disMiss {
//    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:7 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
////          [bokong setFrame:CGRectMake(BOKONG_SPACE,WINDOW.bounds.size.height+bokongViewHeight,chuckView.bounds.size.width-BOKONG_SPACE*2, bokongViewHeight)];
//    } completion:^(BOOL finished) {
//            [chuckView removeFromSuperview];
//            isShow=NO;
//    }];

    
    [UIView animateKeyframesWithDuration:1 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        bokong.alpha=0;
        [bokong setFrame:CGRectMake(BOKONG_SPACE,WINDOW.bounds.size.height+bokongViewHeight,chuckView.bounds.size.width-BOKONG_SPACE*2, bokongViewHeight)];
        if ([self.delegate respondsToSelector:@selector(boKongHadDimssed)]) {
            [self.delegate boKongHadDimssed];
        }
    } completion:^(BOOL finished) {
        isShow=NO;
        [chuckView removeFromSuperview];

    }];
    
}

-(void)showView {
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:0 animations:^{
        [bokong setFrame:CGRectMake(BOKONG_SPACE,chuckView.bounds.size.height-bokongViewHeight-69,chuckView.bounds.size.width-BOKONG_SPACE*2,bokongViewHeight)];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            [bokong setFrame:CGRectMake(BOKONG_SPACE, SCREEN_SIZE.height-bokongViewHeight-49,chuckView.bounds.size.width-BOKONG_SPACE*2,bokongViewHeight)];
            isShow=YES;
        }];
    }];
}

- (void)createViews {
//    if (chuckView) return;
    // chuckview
    chuckView=[[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    float oneWidth=(WINDOW.bounds.size.width-BOKONG_SPACE)/4-BOKONG_SPACE*1.5;
    bokongViewHeight=oneWidth*2+3*BOKONG_SPACE+2*LABEL_HEIGHT;
    bokong=[[UIImageView alloc]initWithFrame:CGRectMake(BOKONG_SPACE, WINDOW.bounds.size.height,chuckView.bounds.size.width-BOKONG_SPACE*2, bokongViewHeight)];
    bokong.userInteractionEnabled=YES;
//    [bokong setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bokong_bg"]]];
    [bokong setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"bokong_bg" ofType:@"png"]]];
    
    bokong.layer.cornerRadius=8;
//    [chuckView addGestureRecognizer:tap];
    
    //buttons
    NSArray *strArray=@[@"上一首",@"切歌",@"播停", @"下一首",@"原/伴",@"重唱"];
    NSMutableArray *btnArray=[[NSMutableArray alloc]init];
    for (int i=0;i<4;i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame=CGRectMake(BOKONG_SPACE*(i+1)+i*oneWidth,BOKONG_SPACE,oneWidth,oneWidth);
        button.tag=i;
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"bokong%d",i]] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(bokongBtn_clicked:) forControlEvents:UIControlEventTouchUpInside];
        [bokong addSubview:button];
        
        //lable
        
        UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(button.frame.origin.x, CGRectGetMaxY(button.frame),button.bounds.size.width,(LABEL_HEIGHT))];
        lable.text=strArray[i];
        lable.font=[UIFont systemFontOfSize:14];
        lable.textAlignment=NSTextAlignmentCenter;
        lable.textColor=[UIColor whiteColor];
        [bokong addSubview:lable];
        [btnArray addObject:lable];
    }

    
    UILabel *refreBtn=btnArray[0];
    int b=4;
    for (int i=0;i<4;i+=3) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.Frame=CGRectMake(BOKONG_SPACE*(i+1)+i*oneWidth,CGRectGetMaxY(refreBtn.frame)+BOKONG_SPACE,oneWidth,oneWidth);
        button.tag=b;
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"bokong%d",b]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(bokongBtn_clicked:) forControlEvents:UIControlEventTouchUpInside];
        [btnArray addObject:button];
        [bokong addSubview:button];
        
        UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(button.frame.origin.x, button.bounds.size.width+button.frame.origin.y,button.bounds.size.width,(LABEL_HEIGHT))];
        lable.text=strArray[b];
        lable.textColor=[UIColor whiteColor];
        lable.font=[UIFont systemFontOfSize:14];
        lable.textAlignment=NSTextAlignmentCenter;
        [bokong addSubview:lable];
        b++;

    }
    
    refreBtn=btnArray[4];
//    UIButton *exitBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];;
//    exitBtn.frame=CGRectMake((bokong.bounds.size.width-60)/2, refreBtn.frame.origin.y+10, 60, 40);
//    exitBtn.tag=6;
//    exitBtn.backgroundColor=[UIColor groupTableViewBackgroundColor];
//    [exitBtn setImage:[UIImage imageNamed:@"bokong_shouqi"] forState:UIControlStateNormal];
//    exitBtn.tintColor=[UIColor whiteColor];
//    [exitBtn addTarget:self action:@selector(bokongBtn_clicked:) forControlEvents:UIControlEventTouchUpInside];

    UIImageView *exitBtn=[[UIImageView alloc]initWithFrame:CGRectMake((bokong.bounds.size.width-60)/2, refreBtn.frame.origin.y+10, 60, 60)];
    exitBtn.tag=6;
    exitBtn.userInteractionEnabled=YES;
    NSMutableArray *imageArray=[[NSMutableArray alloc]init];
    for (int i=1;i<4;i++) {
        NSLog(@"%@",[NSString stringWithFormat:@"bokong_shouqi%d",i]);
        UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"bokong_shouqi%d",i]];
        [imageArray addObject:image];
    }
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disMiss)];
    [exitBtn addGestureRecognizer:tap];
    exitBtn.animationImages=imageArray;
    exitBtn.animationDuration=0.5;
    [exitBtn startAnimating];
    [btnArray addObject:exitBtn];
    
    [bokong addSubview:exitBtn];
    
    
    [chuckView addSubview:bokong];
    [[UIApplication sharedApplication].keyWindow addSubview:chuckView];
}


- (void)bokongBtn_clicked:(id)sender {
    UIButton *btn=(UIButton*)sender;
    switch (btn.tag) {
        case 0: {
            break;
        }
        case 1: {
            break;
        }
        case 2: {
            break;
        }
        case 3: {
            break;
        }
        case 4: {
            break;
        }
        case 5: {
            break;
        }
        case 6: {
            [self disMiss];
            break;
        }
        default:
            break;
    }
}


@end
