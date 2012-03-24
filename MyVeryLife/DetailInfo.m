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
#import "AppDelegate.h"

@implementation DetailInfo

@synthesize product;

@synthesize titleLabel;
@synthesize priceLabel;
@synthesize sellCountLabel;
@synthesize proTypeLabel;
@synthesize locationLabel;

@synthesize  colorLabel;
@synthesize  sizeLabel;

@synthesize desc;

@synthesize  commentBtn;
@synthesize buyBtn;

@synthesize waitingView;


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
- (UIImageView *)imageAtIndex:(int)index {
    NSURL *url = [NSURL URLWithString:product.pic_url];
    UIImageView * tmpView = [[UIImageView alloc]init];
    [tmpView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"hold.png"]];
    return tmpView;
    
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
    UITouch * touch = [touches anyObject];
    NSLog(@"%@",touch);
    if([touch locationInView:touch.window].y > 300)
        return;

    
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
    
    
    CGSize newSize=self.view.frame.size;
    newSize.height+=360;
    self.scrollView.contentSize=newSize;
    //    [self.scrollView setFrame:CGRectMake(0.0f, 260.0f, scrollView.frame.size.width, scrollView.frame.size.height)];
    scrollView.delegate = self;
    
    if (pagePhotoView == nil) 
    {
        // 创建下拉视图
		PagePhotosView * view = [[PagePhotosView alloc] initWithFrame:CGRectMake(0.0f, 0.0 , 320.0f, 260.f) withDataSource:self withBImage:[UIImage imageNamed:@"bg.png"]];
		[self.scrollView addSubview:view];
        //        [self.tableView setContentOffset:CGPointMake(0.0f, -260.0f) animated:FALSE];
        //        [self.tableView scrollsToTop];
        //        [self.tableView setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 367.0f)];
        //        self.tableView.frame.origin.x;
		pagePhotoView = view;
        
	}
    
    if([product.wap_desc length] > 0)
        [self refreshUI];
    else
    {        
        NSThread* myThread = [[NSThread alloc] initWithTarget:self
                                                 selector:@selector(getDetailData)
                                                   object:nil];

        AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
        delegate.curThread = myThread;

        [myThread start];
    }
}

-(void)getDetailData
{
    [SingleModel getSingleModal].delegate = self;
    [[SingleModel getSingleModal] getProDetailInfo:product];
}

#pragma - taobao
-(void)finishedDetailData
{
    [self performSelectorOnMainThread:@selector(dataReady) withObject:nil waitUntilDone:NO];

}

-(void)refreshUI
{
    self.titleLabel.text = product.title;
    self.priceLabel.text = product.price;
    self.sellCountLabel.text = product.sell_count;
    self.locationLabel.text = product.location;
    /*
     UILabel * colorLabel;
     UILabel * sizeLabel;
     
     UIButton * commentBtn;
     UIButton * buyBtn;
     */
    self.title=@"宝贝详情";
    self.desc.text = [self flatHtml:product.wap_desc];
    if([product.item_type compare:@"new"] == NSOrderedSame)
        self.proTypeLabel.text = @"全新";
    else if([product.item_type compare:@"unused"] == NSOrderedSame)
        self.proTypeLabel.text = @"闲置";
    else if([product.item_type compare:@"second"] == NSOrderedSame)
        self.proTypeLabel.text = @"二手";
    
    NSLog(@"id-%@,Desc-%@",product.num_iid,product.item_type);
}

-(void)dataReady
{
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    delegate.curThread = nil;
    [self refreshUI];
}

- (NSString *) flatHtml:(NSString *) html {
    
    NSScanner *theScanner;
    NSString *text = nil;
    
    theScanner = [NSScanner scannerWithString:html];
    
    while ([theScanner isAtEnd] == NO) {
        
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ; 
        
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        if (! [text compare:@"</p"])
            html = [html stringByReplacingOccurrencesOfString:
                [ NSString stringWithFormat:@"%@>", text]
                                               withString:@"\n"];
        else
            html = [html stringByReplacingOccurrencesOfString:
                    [ NSString stringWithFormat:@"%@>", text]
                                                   withString:@""];
        
    } // while //

    html = [html stringByReplacingOccurrencesOfString:
            [ NSString stringWithFormat:@"%@",@"&nbsp;"]
                                           withString:@""];

    return html;
    
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
