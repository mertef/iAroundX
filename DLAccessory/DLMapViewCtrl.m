//
//  DLMapViewCtrl.m
//  DLAccessory
//
//  Created by Mertef on 1/7/14.
//  Copyright (c) 2014 Zhang Mertef. All rights reserved.
//

#import "DLMapViewCtrl.h"

@interface DLMapViewCtrl ()

@end

@implementation DLMapViewCtrl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [self.tabBarController.tabBar setHidden:NO];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.cMapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.cMapView.mapType = MKMapTypeStandard;
    self.cMapView.delegate = self;
    self.cMapView.showsUserLocation = YES;
    MKCoordinateRegion tCoorindateRegion =  MKCoordinateRegionMakeWithDistance(self.tLocationCoordinate2d, 200, 200);
    self.cMapView.region = tCoorindateRegion;
    self.cMapView.centerCoordinate = self.tLocationCoordinate2d;
    [self.view addSubview:self.cMapView];
    NSLog(@"my locations is user location! %f,%f", self.tLocationCoordinate2d.latitude, self.tLocationCoordinate2d.longitude);

	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    NSLog(@"user location! %f,%f", userLocation.coordinate.latitude, userLocation.coordinate.longitude);
    [mapView setCenterCoordinate:userLocation.coordinate animated:YES];
}
@end
