//
//  HomeTabController.m
//  MyVeryLife
//
//  Created by Rock on 12-1-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HomeTabController.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"

@implementation HomeTabController

@synthesize pagePhotoView,refreshHeaderView,reLoading,updateDate;

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

    
    
    if (refreshHeaderView == nil) 
    {
        // 创建下拉视图
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		refreshHeaderView = view;
        self.updateDate = [NSDate date];
	}
	
	// 更新时间
	[refreshHeaderView refreshLastUpdatedDate];    //Hide Tool Bar
//    self.navigationController.navigationBarHidden = YES;
//    self.tabBarController.tabBar.hidden = NO;
    
    if (pagePhotoView == nil) 
    {
        // 创建下拉视图
		PagePhotosView * view = [[PagePhotosView alloc] initWithFrame:CGRectMake(0.0f, 0.0 , 320.0f, 260.f) withDataSource:self withBImage:[UIImage imageNamed:@"Default@2x.png"]];
		[self.tableView addSubview:view];
//        [self.tableView setContentOffset:CGPointMake(0.0f, -260.0f) animated:FALSE];
//        [self.tableView scrollsToTop];
//        [self.tableView setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 367.0f)];
//        self.tableView.frame.origin.x;
		pagePhotoView = view;
        
	}
    self.reLoading = NO;
    //Disable Tab

//    [SingleModel getSingleModal].delegate = self;
//	[[SingleModel getSingleModal]refreshData:YES];
//    [self.navigationController setTitle:@"金太家の日式良品店"];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
// 页面滚动时回调
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{	
    //NSLog(@"scrollViewDidScroll");
	[refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}
// 滚动结束时回调
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{	
    //NSLog(@"scrollViewDidEndDragging");
	[refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark EGORefreshTableHeaderDelegate Methods
// 开始刷新时回调
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{	
    NSLog(@"egoRefreshTableHeaderDidTriggerRefresh");
    reLoading = YES;
    [SingleModel getSingleModal].delegate = self;
    [[SingleModel getSingleModal]refreshData:YES];
}
// 下拉时回调
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{	
    NSLog(@"egoRefreshTableHeaderDataSourceIsLoading");
	return reLoading; // should return if data source model is reloading
}
// 请求上次更新时间时调用
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{	
    NSLog(@"egoRefreshTableHeaderDataSourceLastUpdated");
	return [NSDate date]; // should return date data source was last changed
}

// 刷新结束时调用
- (void)doneLoadingTableViewData
{
	//  model should call this when its done loading
	self.reLoading = NO;
	[refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

#pragma taobao data
-(void) finishedRefreshData
{
    NSLog(@"finishedRefreshData-end");
    self.reLoading = NO;
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
    
    AppDelegate * delgate = [[UIApplication sharedApplication]delegate];
    delgate.refreshHomeTab = YES;
    delgate.refreshProTab = YES;

    
    //refresh table and photoview
    delgate.refreshHomeTab = NO;
    [self.tableView reloadData];
    [self.pagePhotoView refreshData:self];
    
//	[refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];

//    [self.tabBarController reloadInputViews];
    
//    [self.tableView reloadData];
//    [self.pagePhotoView refreshData:self];
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

    DetailInfo * controller = [[DetailInfo alloc]initWithNibName:@"DetailInfo" bundle:nil];
    
    controller.product = product;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController setTitle:@"宝贝详情"];
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
