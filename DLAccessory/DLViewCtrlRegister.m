//
//  DLViewCtrlRegister.m
//  DLAccessory
//
//  Created by Mertef on 1/23/14.
//  Copyright (c) 2014 Zhang Mertef. All rights reserved.
//

#import "DLViewCtrlRegister.h"
#import "DLViewRegister.h"

@interface DLViewCtrlRegister ()

@end

@implementation DLViewCtrlRegister

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.navigationController.navigationBar.frame) - CGRectGetHeight(self.tabBarController.tabBar.frame) - 20.0f);
	// Do any additional setup after loading the view.
    NSLog(@"%@", NSStringFromCGRect(self.view.bounds));
    self.ccviewRegister = [[DLViewRegister alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.ccviewRegister];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
