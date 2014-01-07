//
//  DLMapViewCtrl.h
//  DLAccessory
//
//  Created by Mertef on 1/7/14.
//  Copyright (c) 2014 Zhang Mertef. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface DLMapViewCtrl : UIViewController<MKMapViewDelegate>
@property(strong, nonatomic) MKMapView* cMapView;
@property(assign, nonatomic) CLLocationCoordinate2D tLocationCoordinate2d;
@property(strong, nonatomic) NSDictionary* cdicInfo;
@end
