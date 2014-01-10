//
//  DLTabbarViewCtr.m
//  DLAccessory
//
//  Created by Mertef on 1/10/14.
//  Copyright (c) 2014 Zhang Mertef. All rights reserved.
//

#import "DLTabbarViewCtr.h"

@interface DLTabbarViewCtr ()

@end

@implementation DLTabbarViewCtr

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}
@end
