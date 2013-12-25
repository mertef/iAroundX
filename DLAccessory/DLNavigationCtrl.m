//
//  DLNavigationCtrl.m
//  DLAccessory
//
//  Created by Mertef on 12/25/13.
//  Copyright (c) 2013 Zhang Mertef. All rights reserved.
//

#import "DLNavigationCtrl.h"
#import "DLMCConfig.h"

@interface DLNavigationCtrl ()

@end

@implementation DLNavigationCtrl

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
    self.navigationBar.tintColor = [UIColor colorWithRed:137.0f/255.0f green:172.0f/255.0f blue:20.0f/255.0f alpha:1.0f];
    self.navigationBar.barTintColor = [UIColor orangeColor];
    self.navigationBar.titleTextAttributes  = @{NSFontAttributeName:[UIFont fontWithName:@"Palatino-Roman" size:18.0], NSTextEffectAttributeName: NSTextEffectLetterpressStyle, NSForegroundColorAttributeName:k_colore_blue};

	// Do any additional setup after loading the view.
}
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
