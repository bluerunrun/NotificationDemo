//
//  AMCalloutAnnotationView.m
//  EasyMeter
//
//  Created by guopu on 22/8/16.
//  Copyright © 2016年 com.EasyTone.easypark. All rights reserved.
//

#import "AMCalloutAnnotationView.h"
#import <Masonry.h>

@implementation AMAnnotation
@synthesize name;

- (NSString *)title{
    return name;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    _coordinate = newCoordinate;
}

@end

@interface AMCalloutAnnotationView()

@property (nonatomic, strong) UIImageView *imgPin;

@property (nonatomic, strong) UIImageView *imgBG;
@property (nonatomic, strong) UILabel *lbTitle;

@end

#define Pin_Width 30
#define Pin_Height 37

#define CalloutView_Width 180
#define CalloutView_Height 53

#define  WIDTH CalloutView_Width
#define  HEIGHT (CalloutView_Height+Pin_Height)

@implementation AMCalloutAnnotationView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        __weak __typeof(&*self)weakSelf = self;
//        AMAnnotation * dcannotation =self.annotation;
        self.imgBG=[[UIImageView alloc] init];
        self.imgBG.image=[UIImage imageNamed:@"icon_bg"];
        self.imgBG.contentMode=UIViewContentModeScaleAspectFill;
        self.imgBG.backgroundColor=[UIColor clearColor];
//        self.imgBG.alpha=0.5;
        [self addSubview:self.imgBG];
        [self.imgBG mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@CalloutView_Width);
            make.height.mas_equalTo(@CalloutView_Height);
            make.top.left.right.equalTo(weakSelf);
        }];
        
        self.imgPin=[[UIImageView alloc] init];
        [self addSubview:self.imgPin];
        [self.imgPin mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@Pin_Width);
            make.height.mas_equalTo(@Pin_Height);
            make.top.equalTo(weakSelf.imgBG.mas_bottom);
            make.centerX.mas_equalTo(weakSelf);
        }];
        
        //內容VIEW 包含彈出內容
        
        //地址
        self.lbTitle = [[UILabel alloc] init];
        self.lbTitle.textColor=[UIColor blackColor];
        self.lbTitle.textAlignment = NSTextAlignmentCenter;
        self.lbTitle.font=[UIFont systemFontOfSize:13];
        self.lbTitle.text=[NSString stringWithFormat:@"%@",@"長按並拖動圖標可調整位置"];
        [self.imgBG addSubview:self.lbTitle];
        [self.lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.imgBG);
            make.centerY.equalTo(weakSelf.imgBG).offset(-6);
        }];
    }
    return self;
}

+(instancetype)calloutViewWithMapView:(MKMapView *)mapView :(NSString *)key{
    AMCalloutAnnotationView *calloutView=(AMCalloutAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:key];
    if (!calloutView) {
        calloutView=[[AMCalloutAnnotationView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
//        calloutView.backgroundColor=[UIColor greenColor];
//        calloutView.alpha = 0.5;
        
    }
    return calloutView;
}

-(void)setImage:(UIImage *)pimage{
    self.imgPin.image=pimage;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
    if (self.selected == selected){
        return;
    }
    
    if (selected){
        self.imgBG.hidden=NO;
    }else{
        self.imgBG.hidden=YES;
    }
    
    [super setSelected:selected animated:animated];
}


@end
