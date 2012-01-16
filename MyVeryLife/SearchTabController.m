//
//  SearchTabController.m
//  MyVeryLife
//
//  Created by Rock on 12-1-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SearchTabController.h"
#import "UIImageView+WebCache.h"

@implementation SearchTabController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma - Tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[SingleModel getSingleModal].itemAllProList count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView 
                             dequeueReusableCellWithIdentifier:@"allprocell"];
	ItemProductModel * product = [[SingleModel getSingleModal].itemAllProList objectAtIndex:indexPath.row];
    UIImageView * proImage = (UIImageView*)[cell viewWithTag:100];
    NSURL *url = [NSURL URLWithString:product.pic_url];
    
    [proImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"hold.png"]];
    //    proImage.image = product.photo;
    UILabel * proTitle = (UILabel *)[cell viewWithTag:101];
    proTitle.text = product.title;
    UILabel * proPrice = (UILabel *)[cell viewWithTag:102];
    proPrice.text = product.price;
    UILabel * proFreight = (UILabel *)[cell viewWithTag:103];
    proFreight.text = product.item_express;
    UILabel * proSold = (UILabel *)[cell viewWithTag:104];
    proSold.text = product.sell_count;
    
    return cell;    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	ItemProductModel * product = [[SingleModel getSingleModal].itemAllProList objectAtIndex:indexPath.row];
    
    DetailInfo * controller = [[DetailInfo alloc]initWithNibName:@"DetailInfo" bundle:nil];
    
    controller.product = product;
    controller.hidesBottomBarWhenPushed = YES;
    //    self.navigationController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (IBAction) sortBySellcount
{
    [[SingleModel getSingleModal] sortBySellCount];
    [self.tableView reloadData];
}
-(IBAction)sortByDate
{
    
}
@end
