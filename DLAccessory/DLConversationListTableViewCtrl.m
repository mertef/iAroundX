//
//  DLConversationListTableViewCtrl.m
//  DLAccessory
//
//  Created by Mertef on 12/24/13.
//  Copyright (c) 2013 Zhang Mertef. All rights reserved.
//

#import "DLConversationListTableViewCtrl.h"

@interface DLConversationListTableViewCtrl ()

@end

@implementation DLConversationListTableViewCtrl

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
    
    UITabBarItem* cItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"k_conversation", nil) image:[UIImage imageNamed:@"conversation"] selectedImage:[UIImage imageNamed:@"conversation-h"]];
    self.tabBarItem = cItem;
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
