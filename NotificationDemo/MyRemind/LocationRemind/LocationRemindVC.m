//
//  LocationRemindVC.m
//  NotificationDemo
//
//  Created by guopu on 2016/12/8.
//  Copyright © 2016年 blue. All rights reserved.
//

#import "LocationRemindVC.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <UserNotifications/UserNotifications.h>
#import "AMCalloutAnnotationView.h"
#import "clsOtherFun.h"

@interface LocationRemindVC ()<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnIsEntryAlert;
@property (weak, nonatomic) IBOutlet UIButton *btnIsExitAlert;
@property (weak, nonatomic) IBOutlet UITextField *tfRadius;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) double currLatitude;
@property (nonatomic, assign) double currLongitude;

@end

@implementation LocationRemindVC

-(void)dealloc{
    if (self.mapView) {
        self.mapView.showsUserLocation = NO;
        self.mapView.userTrackingMode  = MKUserTrackingModeFollow;
        [self.mapView.layer removeAllAnimations];
        [self.mapView removeAnnotations:self.mapView.annotations];
        self.mapView.delegate = nil;
        self.mapView = nil;
    }
    if (self.locationManager) {
        [self.locationManager stopUpdatingLocation];
        self.locationManager.delegate=nil;
        self.locationManager = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.currLatitude = [clsOtherFun getTriggerCoordinate].latitude;
    self.currLongitude = [clsOtherFun getTriggerCoordinate].longitude;
    self.tfRadius.text = [NSString stringWithFormat:@"%.2f",[clsOtherFun getTriggerRadius]];
    [self initMap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)switchEntryAction:(id)sender {
    [self.view endEditing:YES];
    self.btnIsEntryAlert.selected = !self.btnIsEntryAlert.selected;
    [clsOtherFun setTriggerCountDountON:self.btnIsEntryAlert.selected];
    if (!self.btnIsEntryAlert.selected) {
        
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 10.0) {
            [clsOtherFun cancel10LocalNotificationWithIdentifier:LocalNotificationID_CountDown];
        }else{
            [clsOtherFun cancelLocalNotificationWithIdentifier:LocalNotificationID_CountDown];
        }
    }else{
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 10.0) {
            [clsOtherFun add10LocalNotificationWithIdentifier:LocalNotificationID_CountDown Type:LocalNotificationType_CountDown Msg:@"倒计时到了！该干嘛干嘛！" Second:[self.tfRadius.text longLongValue]];
        }
        else{
            [clsOtherFun addLocalNotificationWithIdentifier:LocalNotificationID_CountDown Type:LocalNotificationType_CountDown Msg:@"倒计时到了！该干嘛干嘛！" Second:[self.tfRadius.text longLongValue]]
            ;
        }
    }
}

- (IBAction)switchExitAction:(id)sender {
    [self.view endEditing:YES];
    self.btnIsExitAlert.selected = !self.btnIsExitAlert.selected;
    [clsOtherFun setTriggerLocationON:self.btnIsExitAlert.selected];
    if (!self.btnIsExitAlert.selected) {
        
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 10.0) {
            [clsOtherFun cancel10LocalNotificationWithIdentifier:LocalNotificationID_CountDown];
        }else{
            [clsOtherFun cancelLocalNotificationWithIdentifier:LocalNotificationID_CountDown];
        }
    }else{
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 10.0) {
            [clsOtherFun add10LocalNotificationWithIdentifier:LocalNotificationID_CountDown Type:LocalNotificationType_CountDown Msg:@"倒计时到了！该干嘛干嘛！" Second:[self.tfRadius.text longLongValue]];
        }
        else{
            [clsOtherFun addLocalNotificationWithIdentifier:LocalNotificationID_CountDown Type:LocalNotificationType_CountDown Msg:@"倒计时到了！该干嘛干嘛！" Second:[self.tfRadius.text longLongValue]]
            ;
        }
    }
}

#pragma mark -UITextFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [clsOtherFun setTriggerRadius:[textField.text doubleValue]];
}

#pragma mark -PrivateMethods
- (void)initMap{
    
    //初始化locationManger管理器对象
    self.locationManager = [[CLLocationManager alloc]init];
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=8.0) {
        //是否具有定位权限
        int status = [CLLocationManager authorizationStatus];
        //    NSLog(@"\nstatus :%d",status);
        if(![CLLocationManager locationServicesEnabled] || status!=kCLAuthorizationStatusAuthorizedAlways || status!=kCLAuthorizationStatusAuthorizedWhenInUse){
            //请求权限
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
    
    //设置MKMapView
    self.mapView.delegate=self;
    self.mapView.showsUserLocation=YES;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    self.mapView.mapType=MKMapTypeStandard;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=9.0) {
        self.mapView.showsCompass=NO;
    }

}

- (void)goToPosition:(CLLocationCoordinate2D)coordinate{
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    AMAnnotation *annotation= [[AMAnnotation alloc] init];
    annotation.coordinate=coordinate;
    annotation.name=@"長按並拖動圖標可調整位置";
    annotation.draggable=YES;
    [self.mapView addAnnotation:annotation];
    
    [self.mapView selectAnnotation:annotation animated:YES];
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.01, 0.01));
    [self.mapView setRegion:region animated:YES];
}

#pragma mark -MKMapViewDelegate
- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    
    if([annotation isKindOfClass:[AMAnnotation class]]){
        AMAnnotation *amAnnotation = (AMAnnotation *)annotation;
        AMCalloutAnnotationView *calloutView=[AMCalloutAnnotationView calloutViewWithMapView:mapView :@"AMCallout"];
        calloutView.annotation= amAnnotation;
        calloutView.draggable = amAnnotation.draggable;
        calloutView.canShowCallout = NO;
        calloutView.image=[UIImage imageNamed:@"main_icon_Parking-Metre"];
        return calloutView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    
    if ([view.annotation isKindOfClass:[AMAnnotation class]]) {
        [self.mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
    }
}

////当定位自身时调用
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
//    NSLog(@"经纬度＝%f,%f",loc.longitude,loc.latitude);
//    CLLocationCoordinate2D loc = [userLocation coordinate];
//    self.currLatitude = loc.latitude;
//    self.currLongitude = loc.longitude;
//    [clsOtherFun setTriggerCoordinate:loc];
    [self goToPosition:CLLocationCoordinate2DMake(self.currLatitude, self.currLongitude)];
}

-(void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    self.mapView.showsUserLocation=NO;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState{
    switch (newState) {
        case MKAnnotationViewDragStateStarting:
            break;
        case MKAnnotationViewDragStateDragging:
            break;
        case MKAnnotationViewDragStateEnding:
        {
            self.currLatitude=annotationView.annotation.coordinate.latitude;
            self.currLongitude=annotationView.annotation.coordinate.longitude;
            [clsOtherFun setTriggerCoordinate:CLLocationCoordinate2DMake(self.currLatitude, self.currLongitude)];
            [annotationView setDragState:MKAnnotationViewDragStateNone animated:NO];
            if (oldState != MKAnnotationViewDragStateNone) {
                NSLog(@"Drag coordinate : %f %f",annotationView.annotation.coordinate.latitude,annotationView.annotation.coordinate.longitude);
            }
        }
            break;
        case MKAnnotationViewDragStateCanceling:
            [self goToPosition:CLLocationCoordinate2DMake(self.currLatitude, self.currLongitude)];
        default:
            break;
    }
    
}

@end
