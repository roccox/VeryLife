//
//  DetailInfo.m
//  MyVeryLife
//
//  Created by Rock on 12-1-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DetailInfo.h"
#import "UIImageView+WebCache.h"
#import "UIScrollView+TouchScroll.h"
#import "DetailInfoImage.h"
#import "DetailInfoWeb.h"
#import "CommentController.h"

@implementation DetailInfo

@synthesize product;

@synthesize titleLabel;
@synthesize priceLabel;
@synthesize sellCountLabel;
@synthesize proTypeLabel;
@synthesize locationLabel;

@synthesize  colorLabel;
@synthesize  sizeLabel;

@synthesize  commentBtn;
@synthesize buyBtn;

@synthesize scrollView;

@synthesize  pagePhotoView;

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

#pragma - pagephotoview
// 有多少页
//
- (int)numberOfPages {
    	return 1;
}

// 每页的图片
//
- (UIImage *)imageAtIndex:(int)index {
    NSURL *url = [NSURL URLWithString:product.pic_url];
    UIImageView * tmpView = [[UIImageView alloc]init];
    [tmpView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"hold.png"]];
    return tmpView.image;
    
    /*
     return [[SingleModel getSingleModal].itemHotProList];
     
     NSString *imageName = [NSString stringWithFormat:@"1933_%d.jpg", index + 1];
     return [UIImage imageNamed:imageName];
     
     */}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesEnded");
	ItemProductModel * product = [[SingleModel getSingleModal].itemHotProList objectAtIndex: [pagePhotoView getCurPage]];
    
    DetailInfoImage * controller = [[DetailInfoImage alloc]initWithNibName:@"DetailInfoImage" bundle:nil];
    NSURL *url = [NSURL URLWithString:product.pic_url];
    controller.url = url;
    controller.hidesBottomBarWhenPushed = YES;
    //    self.navigationController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma - button action
- (IBAction)commentBtnClicked
{
    CommentController * controller = [[CommentController alloc]initWithNibName:@"CommentController" bundle:nil];
    controller.num_iid = product.num_iid;
    
    controller.hidesBottomBarWhenPushed = YES;
    //    self.navigationController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];

}

- (IBAction)buyBtnClicked
{
    DetailInfoWeb * controller = [[DetailInfoWeb alloc]initWithNibName:@"DetailInfoWeb" bundle:nil];
    NSURL *url = [NSURL URLWithString: product.wap_detail_url];
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:url];
    controller.request = theRequest;
    
    controller.hidesBottomBarWhenPushed = YES;
    //    self.navigationController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGSize newSize=self.view.frame.size;
    newSize.height+=360;
    self.scrollView.contentSize=newSize;
//    [self.scrollView setFrame:CGRectMake(0.0f, 260.0f, scrollView.frame.size.width, scrollView.frame.size.height)];
    scrollView.delegate = self;

    if (pagePhotoView == nil) 
    {
        // 创建下拉视图
		PagePhotosView * view = [[PagePhotosView alloc] initWithFrame:CGRectMake(0.0f, 0.0 , 320.0f, 260.f) withDataSource:self];
		[self.scrollView addSubview:view];
        //        [self.tableView setContentOffset:CGPointMake(0.0f, -260.0f) animated:FALSE];
        //        [self.tableView scrollsToTop];
        //        [self.tableView setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 367.0f)];
        //        self.tableView.frame.origin.x;
		pagePhotoView = view;
        
	}
    self.titleLabel.text = product.title;
    self.priceLabel.text = product.price;
    self.sellCountLabel.text = product.sell_count;
    self.proTypeLabel.text = product.item_type;
    self.locationLabel.text = product.location;
    /*
     UILabel * colorLabel;
     UILabel * sizeLabel;
     
     UIButton * commentBtn;
     UIButton * buyBtn;
     */
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

@end
