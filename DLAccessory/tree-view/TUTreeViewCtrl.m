//
//  TUTreeViewCtrl.m
//  TreeUI
//
//  Created by Zhang Mertef on 11/7/13.
//  Copyright (c) 2013 Zhang Mertef. All rights reserved.
//

#import "TUTreeViewCtrl.h"
#import "TUTreeConfig.h"
@interface TUTreeViewCtrl ()

@end

@implementation TUTreeViewCtrl
@synthesize cmutarrData = m_c_mut_arr_data;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Tree view Test";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    m_c_mut_arr_data = [[NSMutableArray alloc] init];

//    NSLog(@"before frame is %@", NSStringFromCGRect(self.view.frame));
    CGRect srectViewFrame  = self.view.frame;
    srectViewFrame.size.height -= (CGRectGetHeight(self.navigationController.navigationBar.frame) + CGRectGetHeight(self.tabBarController.tabBar.frame));
    self.view.frame = srectViewFrame;
    NSLog(@"end frame is %@", NSStringFromCGRect(self.view.frame));
    self.cTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self registerTableviewCells];
    
    self.cTableView.delaysContentTouches = YES;
    self.cTableView.delegate = self;
    self.cTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.cTableView.dataSource = self;
    [self.view addSubview:self.cTableView];
    
 
//    [self emulateData];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)registerTableviewCells {
    [self.cTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"id_cell"];
    [self.cTableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"header_footer"];
}
-(void)useGesture {
    self.cTableView.canCancelContentTouches = NO;
    UISwipeGestureRecognizer* cSwipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(actionBeginEdit:)];
    [self.cTableView addGestureRecognizer:cSwipeGes];
}
-(void)actionBeginEdit:(UIPanGestureRecognizer*)acSwipeGes {
    CGPoint cPoint =  [acSwipeGes locationInView:self.cTableView];
    NSArray* carrListCells = [self.cTableView visibleCells];
    static UITableViewCell* cellSelected = nil;
    static CGPoint sPointSelected;
    static NSInteger iSelectedIndex = -1;
    switch (acSwipeGes.state) {
        case UIGestureRecognizerStateBegan:
        {
            if (!cellSelected) {
                for (UITableViewCell* cellItem in carrListCells) {
                    if (CGRectContainsPoint(cellItem.frame, cPoint)) {
                        cellSelected = cellItem;
                        sPointSelected = cellItem.center;
                        iSelectedIndex = [[self.cTableView indexPathForCell:cellSelected] row];
                        break;
                    }
                }
                
            }
            if (!cellSelected) {
                return;
            }
        }
            break;
        case UIGestureRecognizerStateEnded: {
            sPointSelected = CGPointZero;
            cellSelected = nil;
            iSelectedIndex = -1;
            [self.cTableView reloadData];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            
            cellSelected.center = CGPointMake(CGRectGetWidth(cellSelected.frame) * 0.5f, cPoint.y);
            NSArray* carrListCells = [self.cTableView visibleCells];
            for (UITableViewCell* cellItem in carrListCells) {
                if ([cellItem isEqual:cellSelected]) {
                    continue;
                }
                CGRect srectIntersected = CGRectIntersection(cellItem.frame, cellSelected.frame);
                if (!CGRectIsInfinite(srectIntersected) && CGRectGetHeight(srectIntersected) > CGRectGetHeight(cellItem.frame) * 0.5f) {
                    NSIndexPath* cindexpathFrom = [self.cTableView indexPathForCell:cellItem];
//                    NSIndexPath* cindexpathTo =[self.tableView indexPathForCell:cellSelected];
//                    NSLog(@"exchange index is %d  %d", [cindexpathFrom row], [cindexpathTo row]);
                    
                    [m_c_mut_arr_data exchangeObjectAtIndex:[cindexpathFrom row] withObjectAtIndex:iSelectedIndex];
                    iSelectedIndex = [cindexpathFrom row];

                    [UIView animateWithDuration:.5f animations:^(void){
                        cellSelected.center = cellItem.center;
                        cellItem.center = sPointSelected;
                        sPointSelected = cellSelected.center;
                      
                    }completion:^(BOOL abFinished){
                        [self.cTableView bringSubviewToFront:cellItem];
                        [self.cTableView bringSubviewToFront:cellSelected];

                    }];
                    break;
                }
            }
        }
            break;
        default:
            break;
    }
    
}
-(void)emulateData {
    
    NSDictionary* cdicItem = @{k_id:@1,
                               k_parent_id:@0,
                               k_content:@"hello--0",
                               k_order:@0,
                               k_level:@0
                               };
    [m_c_mut_arr_data addObject:cdicItem];
    //level 0
    cdicItem = @{k_id:@1,
                               k_parent_id:@0,
                               k_content:@"hello--1",
                               k_order:@1,
                               k_level:@0
                               };
    [m_c_mut_arr_data addObject:cdicItem];
    
        cdicItem = @{k_id:@5,
                     k_parent_id:@1,
                     k_content:@"hello-sub-1",
                     k_order:@0,
                     k_level:@1
                     };
        [m_c_mut_arr_data addObject:cdicItem];
    
        cdicItem = @{k_id:@6,
                     k_parent_id:@1,
                     k_content:@"hello-sub-2",
                     k_order:@0,
                     k_level:@1
                     };
        [m_c_mut_arr_data addObject:cdicItem];

    
    cdicItem = @{k_id:@2,
                 k_parent_id:@0,
                 k_content:@"hello--2",
                 k_order:@0,
                 k_level:@0
                 };
    [m_c_mut_arr_data addObject:cdicItem];
    
    cdicItem = @{k_id:@3,
                 k_parent_id:@0,
                 k_content:@"hello--3",
                 k_order:@0,
                 k_level:@0
                 };
    [m_c_mut_arr_data addObject:cdicItem];
    
    cdicItem = @{k_id:@4,
                 k_parent_id:@0,
                 k_content:@"hello--4",
                 k_order:@0,
                 k_level:@0
                 };
    [m_c_mut_arr_data addObject:cdicItem];

}

- (void)dealloc
{
    self.cmutarrData = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [m_c_mut_arr_data count];
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

/*
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView* cview  = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header_footer"];
    UIView* cviewBg = [[UIView alloc] initWithFrame:cview.bounds];
    cview.backgroundView = cviewBg;
    cviewBg.backgroundColor = [UIColor orangeColor];
    cview.tintColor = [UIColor orangeColor];
    
    return cview;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView* cview  = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header_footer"];
    UIView* cviewBg = [[UIView alloc] initWithFrame:cview.bounds];
    cview.backgroundView = cviewBg;
    cviewBg.backgroundColor = [UIColor redColor];
    cview.tintColor = [UIColor orangeColor];
    
    return cview;

}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"id_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if ([[cell gestureRecognizers] count] == 0) {
        UIPanGestureRecognizer* cPanGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(actionBeginEdit:)];
        [cell addGestureRecognizer:cPanGes];
        cPanGes.enabled = NO;
    }
   
    NSDictionary* cdicItem = [m_c_mut_arr_data objectAtIndex:[indexPath row]];
    cell.indentationLevel = [cdicItem[k_level] integerValue];

//    NSLog(@"%@", [cdicItem description]);
    
    cell.textLabel.text = cdicItem[k_content];
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell* cell  = [tableView cellForRowAtIndexPath:indexPath];
    }

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
   
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.cmutarrData removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{

    NSMutableDictionary* cmutdicItem0 = [m_c_mut_arr_data objectAtIndex:[fromIndexPath row]];
    NSMutableDictionary* cmutdicItem1 = [m_c_mut_arr_data objectAtIndex:[fromIndexPath row]];
    NSNumber* cnumberItem1Order = [cmutdicItem1 objectForKey:k_order];    
    [cmutdicItem1 setObject:[cmutdicItem0 objectForKey:k_order] forKey:k_order];
    [cmutdicItem0 setObject:cnumberItem1Order forKey:k_order];

    [m_c_mut_arr_data exchangeObjectAtIndex:[toIndexPath row] withObjectAtIndex:[fromIndexPath row]];
    [self.cTableView reloadData];
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell gestureRecognizers]) {
        [[[cell gestureRecognizers] firstObject] setEnabled:YES];
    }

}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell gestureRecognizers]) {
        [[[cell gestureRecognizers] firstObject] setEnabled:NO];
    }
}
/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
