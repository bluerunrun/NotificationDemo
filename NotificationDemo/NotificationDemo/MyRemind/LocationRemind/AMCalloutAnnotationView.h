//
//  AMCalloutAnnotationView.h
//  EasyMeter
//
//  Created by guopu on 22/8/16.
//  Copyright © 2016年 com.EasyTone.easypark. All rights reserved.
//


#import <MapKit/MapKit.h>


@interface AMAnnotation : NSObject<MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL draggable;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end


@interface AMCalloutAnnotationView : MKAnnotationView

+(instancetype)calloutViewWithMapView:(MKMapView *)mapView :(NSString *)key;

@end