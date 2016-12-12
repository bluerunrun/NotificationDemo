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

@property (weak, nonatomic) IBOutlet UIButton *btnIsAlert;
@property (weak, nonatomic) IBOutlet UITextField *tfRadius;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (assign, nonatomic) BOOL isAlert;
@property (assign, nonatomic) double radius;
@property (nonatomic, assign) CLLocationCoordinate2D currCoordinate;

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
    
    self.currCoordinate = [clsOtherFun getTriggerLocationCoordinate];
    self.radius = [clsOtherFun getTriggerLocationRadius];
    if (self.radius > 0) {
        self.isAlert = [clsOtherFun getTriggerLocationON];
    }else{
        self.isAlert = NO;
    }
    
    [self initMap];
    UILongPressGestureRecognizer * longGes=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longGes.minimumPressDuration = 1.0;
    [self.mapView addGestureRecognizer:longGes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setIsAlert:(BOOL)isAlert{
    _isAlert = isAlert;
    self.btnIsAlert.selected = isAlert;
    [clsOtherFun setTriggerLocationON:isAlert];
    if (!isAlert) {
        
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 10.0) {
            [clsOtherFun cancel10LocalNotificationWithIdentifier:LocalNotificationID_Location];
        }else{
            [clsOtherFun cancelLocalNotificationWithIdentifier:LocalNotificationID_Location];
        }
    }else{
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 10.0) {
            [clsOtherFun add10LocalNotificationWithIdentifier:LocalNotificationID_Location Msg:@"倒计时到了！该干嘛干嘛！" Location:self.currCoordinate radius:self.radius];
        }
        else{
            [clsOtherFun addLocalNotificationWithIdentifier:LocalNotificationID_Location Msg:@"倒计时到了！该干嘛干嘛！" Location:self.currCoordinate radius:self.radius]
            ;
        }
    }
}

-(void)setRadius:(double)radius{
    _radius = radius;
    self.tfRadius.text = [NSString stringWithFormat:@"%.2f",radius];
    [clsOtherFun setTriggerLocationRadius:radius];
}

-(void)setCurrCoordinate:(CLLocationCoordinate2D)currCoordinate{
    _currCoordinate = currCoordinate;
    [clsOtherFun setTriggerLocationCoordinate:currCoordinate];
}

#pragma mark - Response

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture{
    
    if (gesture.state == UIGestureRecognizerStateEnded){
        return;
    }
    
    //坐标转换
    CGPoint touchPoint = [gesture locationInView:_mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [_mapView convertPoint:touchPoint toCoordinateFromView:_mapView];
    
    self.currCoordinate = touchMapCoordinate;
    if (self.isAlert) {
        self.isAlert = YES;
    }
    [self goToPosition:touchMapCoordinate];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)switchAction:(id)sender {
    [self.view endEditing:YES];
    if ([self.tfRadius.text doubleValue] <= 0) {
        [clsOtherFun showAlertMessage:@"半径不能小于0米！"];
        self.isAlert = NO;
        return;
    }
    
    self.btnIsAlert.selected = !self.btnIsAlert.selected;
    self.isAlert = self.btnIsAlert.selected;
}

#pragma mark -UITextFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if ([self.tfRadius.text doubleValue] <= 0) {
        [clsOtherFun showAlertMessage:@"半径不能小于0米！"];
        self.isAlert = NO;
        return;
    }
    
    self.radius = [textField.text doubleValue];
    if (self.isAlert) {
        self.isAlert = YES;
    }
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
    
//    CLLocationCoordinate2D loc = [userLocation coordinate];
//    self.currLatitude = loc.latitude;
//    self.currLongitude = loc.longitude;
//    NSLog(@"经纬度＝%f,%f",loc.longitude,loc.latitude);
    [self goToPosition:self.currCoordinate];
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
            self.currCoordinate=annotationView.annotation.coordinate;
            if (self.isAlert) {
                self.isAlert = YES;
            }
            [annotationView setDragState:MKAnnotationViewDragStateNone animated:NO];
            if (oldState != MKAnnotationViewDragStateNone) {
                NSLog(@"Drag coordinate : %f %f",annotationView.annotation.coordinate.latitude,annotationView.annotation.coordinate.longitude);
            }
        }
            break;
        case MKAnnotationViewDragStateCanceling:
            [self goToPosition:self.currCoordinate];
        default:
            break;
    }
    
}

@end
