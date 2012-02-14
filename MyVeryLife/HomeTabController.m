//
//  HomeTabController.m
//  MyVeryLife
//
//  Created by Rock on 12-1-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HomeTabController.h"
#import "UIImageView+WebCache.h"

@implementation HomeTabController

@synthesize pagePhotoView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma - for pagephotoview
// 有多少页
//
- (int)numberOfPages {
    return [[SingleModel getSingleModal].itemNewProList count];
//	return 5;
}

// 每页的图片
//
- (UIImageView *)imageAtIndex:(int)index {
    ItemProductModel * curPro = [[SingleModel getSingleModal].itemNewProList objectAtIndex:index];
    NSURL *url = [NSURL URLWithString:curPro.pic_url];
    UIImageView * tmpView = [[UIImageView alloc]init];
    [tmpView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"hold.png"]];
    return tmpView;

    /*
    return [[SingleModel getSingleModal].itemNewProList];

	NSString *imageName = [NSString stringWithFormat:@"1933_%d.jpg", index + 1];
	return [UIImage imageNamed:imageName];

     */}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesEnded");
    UITouch * touch = [touches anyObject];
    if(![touch.view isKindOfClass:[UIScrollView class]])
        return;


	ItemProductModel * product = [[SingleModel getSingleModal].itemNewProList objectAtIndex: [pagePhotoView getCurPage]];
    
    [[SingleModel getSingleModal] getProDetailInfo:product];
    DetailInfo * controller = [[DetailInfo alloc]initWithNibName:@"DetailInfo" bundle:nil];
    
    controller.product = product;
    controller.hidesBottomBarWhenPushed = YES;
    //    self.navigationController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    
    if (pagePhotoView == nil) 
    {
        // 创建下拉视图
		PagePhotosView * view = [[PagePhotosView alloc] initWithFrame:CGRectMake(0.0f, 0.0 , 320.0f, 260.f) withDataSource:self];
		[self.tableView addSubview:view];
//        [self.tableView setContentOffset:CGPointMake(0.0f, -260.0f) animated:FALSE];
//        [self.tableView scrollsToTop];
//        [self.tableView setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 367.0f)];
//        self.tableView.frame.origin.x;
		pagePhotoView = view;
	}
    [SingleModel getSingleModal].delegate = self;
	[[SingleModel getSingleModal]refreshData:YES];
}

#pragma taobao data
-(void) finishedRefreshData
{
    NSLog(@"finishedRefreshData-end");
    [self.pagePhotoView refreshData:self];
}



#pragma mark - 获取产品信息
-(void)getRecommendedProInfo
{

}

-(void)getNewProInfo
{
}

#pragma - Tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = [[SingleModel getSingleModal].itemHotProList count];
    return count<=10?count:10;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView 
                             dequeueReusableCellWithIdentifier:@"homeprocell"];
	ItemProductModel * product = [[SingleModel getSingleModal].itemHotProList objectAtIndex:indexPath.row];
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
	ItemProductModel * product = [[SingleModel getSingleModal].itemHotProList objectAtIndex:indexPath.row];

    [[SingleModel getSingleModal] getProDetailInfo:product];
    DetailInfo * controller = [[DetailInfo alloc]initWithNibName:@"DetailInfo" bundle:nil];
    
    controller.product = product;
    controller.hidesBottomBarWhenPushed = YES;
//    self.navigationController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];

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
