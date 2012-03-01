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

@synthesize filterList, searchBar;

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.filterList = [[NSMutableArray alloc]init];
    [self.filterList removeAllObjects];
    searchBar.delegate = self;
}


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
    if (isFilted)
        return [self.filterList count];
    else
        return [[SingleModel getSingleModal].itemAllProList count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView 
                             dequeueReusableCellWithIdentifier:@"allprocell"];
    ItemProductModel * product;
	if (isFilted)
        product = [self.filterList objectAtIndex:indexPath.row];
    else
        product = [[SingleModel getSingleModal].itemAllProList objectAtIndex:indexPath.row];

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
    /*
    ProductCell *cell = [tableView 
                             dequeueReusableCellWithIdentifier:@"allprocell"];
    if(cell == nil)
    {
		cell = [[ProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"allprocell"];
//		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        
    }
    
    ItemProductModel * product;
	if (tableView == self.searchDisplayController.searchResultsTableView)
        product = [self.filterList objectAtIndex:indexPath.row];
    else
        product = [[SingleModel getSingleModal].itemAllProList objectAtIndex:indexPath.row];
        
    UIImageView * proImage = cell.myImage;
    NSURL *url = [NSURL URLWithString:product.pic_url];
    
    [proImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"hold.png"]];
    //    proImage.image = product.photo;
    UILabel * proTitle = cell.title;
    proTitle.text = product.title;
    UILabel * proPrice = cell.price;
    proPrice.text = product.price;
    UILabel * proFreight = cell.freight;
    proFreight.text = product.item_express;
    UILabel * proSold = cell.sold;
    proSold.text = product.sell_count;
    
    return cell;    
     */
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ItemProductModel * product;
	if (isFilted)
        product = [self.filterList objectAtIndex:indexPath.row];
    else
        product = [[SingleModel getSingleModal].itemAllProList objectAtIndex:indexPath.row];
    
    DetailInfo * controller = [[DetailInfo alloc]initWithNibName:@"DetailInfo" bundle:nil];
    
    controller.product = product;
    controller.hidesBottomBarWhenPushed = YES;
    //    self.navigationController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    
}

#pragma  - search bar
-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if(text.length == 0)
    {
        isFilted = FALSE;
        return;
    }
    
    isFilted = TRUE;

	[self.filterList removeAllObjects]; // First clear the filtered array.
	

	for (ItemProductModel *product in [SingleModel getSingleModal].itemAllProList)
	{
        //		if ([scope isEqualToString:@"All"] || [product.type isEqualToString:scope])
		{
            NSRange range = [product.title rangeOfString:text options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)];
            if(range.location != NSNotFound)
			{
				[self.filterList addObject:product];
            }
		}
	}

    
    [self.tableView reloadData];

}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = TRUE;
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar resignFirstResponder];
    searchBar.text = @"";
    isFilted = FALSE;
    [self.tableView reloadData];
    searchBar.showsCancelButton = FALSE;
}





-(IBAction) sortByCount
{
    NSMutableArray * list;
    if(isFilted)
        list = self.filterList;
    else
        list = [SingleModel getSingleModal].itemAllProList;
    
    //filter
    ItemProductModel * proL;
    ItemProductModel * proR;
    
    for(int i=0;i<[list count]-1;i++)
    {
        proL = [list objectAtIndex:i];
        for(int j=i+1;j<[list count];j++)
        {
            proR = [list objectAtIndex:j];
            if([proL.sell_count intValue] < [proR.sell_count intValue])
            {
                [list replaceObjectAtIndex:i withObject:proR];
                [list replaceObjectAtIndex:j withObject:proL];
                proL = proR;
            }
        }
    }

    if(isFilted)
        self.filterList = list;
    else
        [SingleModel getSingleModal].itemAllProList = list;

    [self.tableView reloadData];

}

-(IBAction) sortByPrice
{
    NSMutableArray * list;
    if(isFilted)
        list = self.filterList;
    else
        list = [SingleModel getSingleModal].itemAllProList;
    
    //filter
    ItemProductModel * proL;
    ItemProductModel * proR;
    int priceL, priceR;
    
    for(int i=0;i<[list count]-1;i++)
    {
        proL = [list objectAtIndex:i];
        priceL = [proL.price intValue];
        for(int j=i+1;j<[list count];j++)
        {
            proR = [list objectAtIndex:j];
            priceR = [proR.price intValue];
            if(priceL > priceR)
            {
                [list replaceObjectAtIndex:i withObject:proR];
                [list replaceObjectAtIndex:j withObject:proL];
                proL = proR;
                priceL = [proL.price intValue];

            }
        }
    }
    
    if(isFilted)
        self.filterList = list;
    else
        [SingleModel getSingleModal].itemAllProList = list;
    
    [self.tableView reloadData];
}

-(IBAction) sortByListTime
{
    NSMutableArray * list;
    if(isFilted)
        list = self.filterList;
    else
        list = [SingleModel getSingleModal].itemAllProList;
    
    //filter
    ItemProductModel * proL;
    ItemProductModel * proR;
    NSString * dateL, * dateR;
    
    for(int i=0;i<[list count]-1;i++)
    {
        proL = [list objectAtIndex:i];
        dateL = proL.list_time;
        for(int j=i+1;j<[list count];j++)
        {
            proR = [list objectAtIndex:j];
            dateR = proR.list_time;
            if([dateL compare:dateR] ==  NSOrderedAscending)
            {
                [list replaceObjectAtIndex:i withObject:proR];
                [list replaceObjectAtIndex:j withObject:proL];
                proL = proR;
                dateL = proL.list_time;
            }
        }
    }
    
    if(isFilted)
        self.filterList = list;
    else
        [SingleModel getSingleModal].itemAllProList = list;
    
    [self.tableView reloadData];
}

@end
