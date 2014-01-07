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
    MKCoordinateRegion tCoorindateRegion =  MKCoordinateRegionMakeWithDistance(self.tLocationCoordinate2d, 500, 500);
    self.cMapView.region = tCoorindateRegion;
    self.cMapView.centerCoordinate = self.tLocationCoordinate2d;
    [self.view addSubview:self.cMapView];
    
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
