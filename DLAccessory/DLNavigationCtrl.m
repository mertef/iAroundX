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
//    self.navigationBar.barTintColor = [UIColor colorWithRed:97.0f/255.0f green:174.0f/255.0f blue:239.0f/255.0f alpha:1.0f];
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"chatinput"] forBarMetrics:UIBarMetricsDefault];
//    self.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blue0_hl"]];
    self.navigationBar.titleTextAttributes  = @{NSFontAttributeName:[UIFont fontWithName:@"Palatino-Roman" size:18.0], NSTextEffectAttributeName: NSTextEffectLetterpressStyle, NSForegroundColorAttributeName:k_colore_blue};

	// Do any additional setup after loading the view.
}
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
-(BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
