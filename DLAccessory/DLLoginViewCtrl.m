//
//  DLLoginViewCtrl.m
//  DLAccessory
//
//  Created by Mertef on 14-1-12.
//  Copyright (c) 2014年 Zhang Mertef. All rights reserved.
//

#import "DLLoginViewCtrl.h"
#import "DLLoginTableCell.h"
#import "DLMCConfig.h"
#import "DLViewLoginFooter.h"

@interface DLLoginViewCtrl ()
-(void)dismissKeyBoard;
@end

@implementation DLLoginViewCtrl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.cmutarrModel = [[NSMutableArray alloc] init];


        
        NSMutableDictionary* cmutdicLoginName = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                @"login_people",k_login_left_icon,
                                k_name, k_login_name,
                                NSLocalizedString(@"k_user_name", nil), k_login_place_holder,
                                                nil];
        NSMutableDictionary* cmutdicLoginPwd = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                 @"key",k_login_left_icon,
                                                 k_pwd, k_login_name,
                                                 NSLocalizedString(@"k_user_pwd", nil), k_login_place_holder, nil];
        [self.cmutarrModel addObject:cmutdicLoginName];
        [self.cmutarrModel addObject:cmutdicLoginPwd];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = NSLocalizedString(@"k_login_title", nil);
//    CGRect srectTableview = CGRectMake(20.0f, 0.0f, CGRectGetWidth(self.view.bounds) - 40.0f, CGRectGetHeight(self.view.bounds));
    self.cTableview = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.cTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.cTableview];
    self.cTableview.delegate = self;
    self.cTableview.dataSource = self;
    self.ccViewLoginFooter = [[DLViewLoginFooter alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.cTableview.bounds), 36.0f)];
    [self.ccViewLoginFooter.cbtnLogin addTarget:self action:@selector(actionLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.ccViewLoginFooter.cbtnRegister addTarget:self action:@selector(actionRegister:) forControlEvents:UIControlEventTouchUpInside];

    [self.cTableview setTableFooterView:self.ccViewLoginFooter];
    
//    self.cTableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.cTableview.bounds), 44.0f)];
//    self.cTableview.tableHeaderView.backgroundColor = [UIColor clearColor];
	// Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSIndexPath* cIndexpath = [NSIndexPath indexPathForRow:0 inSection:0];
    DLLoginTableCell* ccLoginTableCell = (DLLoginTableCell*)[self.cTableview cellForRowAtIndexPath:cIndexpath];
    if (ccLoginTableCell) {
        [[ccLoginTableCell ctextfieldInput] becomeFirstResponder];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cmutarrModel count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cTableviewCell = nil;
    cTableviewCell = [tableView dequeueReusableCellWithIdentifier:@"id_cell_login"];
    if (!cTableviewCell) {
        cTableviewCell = [[DLLoginTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id_cell_login"];
    }
    DLLoginTableCell* ccLoginTableviewCell = (DLLoginTableCell*)cTableviewCell;
    NSDictionary* cdicItem = [self.cmutarrModel objectAtIndex:[indexPath row]];
    [ccLoginTableviewCell feedInfo:cdicItem];
    return cTableviewCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selected %lu", (long)[indexPath row]);
}
-(void)dismissKeyBoard {
    for (int i = 0; i < [self.cmutarrModel count]; i ++) {
        NSIndexPath* cIndexpath = [NSIndexPath indexPathForRow:i inSection:0];
        DLLoginTableCell* ccLoginTableCell = (DLLoginTableCell*)[self.cTableview cellForRowAtIndexPath:cIndexpath];
        if ([ccLoginTableCell.ctextfieldInput isFirstResponder]) {
            [[ccLoginTableCell ctextfieldInput] resignFirstResponder];
            break;
        }
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self dismissKeyBoard];
}

-(void)actionLogin:(id)aidSender {
    
    NSString* cstrNameValue = [[self.cmutarrModel firstObject] objectForKey:k_login_value];
    NSString* cstrPwdValue = [[self.cmutarrModel lastObject] objectForKey:k_login_value];
    NSLog(@"%@:%@", cstrNameValue, cstrPwdValue);
}
-(void)actionRegister:(id)aiSender {
    NSString* cstrNameValue = [[self.cmutarrModel firstObject] objectForKey:k_login_value];
    NSString* cstrPwdValue = [[self.cmutarrModel lastObject] objectForKey:k_login_value];
    NSLog(@"%@:%@", cstrNameValue, cstrPwdValue);
}

@end
