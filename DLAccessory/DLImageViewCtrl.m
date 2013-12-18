//
//  DLImageViewCtrl.m
//  DLAccessory
//
//  Created by Zhang Mertef on 12/2/13.
//  Copyright (c) 2013 Zhang Mertef. All rights reserved.
//

#import "DLImageViewCtrl.h"

@interface DLImageViewCtrl ()

@end

@implementation DLImageViewCtrl

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
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _cimageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _cimageView.userInteractionEnabled = YES;
    UITapGestureRecognizer* cTapExitGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapExit:)];
    [_cimageView addGestureRecognizer:cTapExitGes];
    [self.view addSubview:_cimageView];
    
}
-(void)actionTapExit:(UITapGestureRecognizer*)acTapGes {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
