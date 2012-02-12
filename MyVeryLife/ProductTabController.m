//
//  SecondViewController.m
//  MyVeryLife
//
//  Created by Rock on 12-1-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ProductTabController.h"

@implementation ProductTabController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma taobao data
-(void) finishedPrepareData
{
    
}


#pragma - Tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[SingleModel getSingleModal].itemCatlist count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView 
                             dequeueReusableCellWithIdentifier:@"catlistcell"];
    
    ItemCategoryModel * cat = [[SingleModel getSingleModal].itemCatlist objectAtIndex:indexPath.row];
    cell.textLabel.text = cat.name;
    return cell;    
}

/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	ItemProductModel * product = [[SingleModel getSingleModal].itemNewProList objectAtIndex:indexPath.row];
    
    DetailInfo * controller = [[DetailInfo alloc]initWithNibName:@"DetailInfo" bundle:nil];
    
    controller.product = product;
    controller.hidesBottomBarWhenPushed = NO;
    //    self.navigationController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    
}
 */

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"cattopro"])
    {
        ProductTabProController *productController = segue.destinationViewController;
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        ItemCategoryModel * cat = [[SingleModel getSingleModal].itemCatlist objectAtIndex:selectedIndexPath.row];
        productController.cat = cat;
    }
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
