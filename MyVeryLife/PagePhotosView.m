//
//  PagePhotosView.m
//  PagePhotosDemo
//
//  Created by Andy soonest on 11-11-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PagePhotosView.h"
#import "UIScrollView+TouchScroll.h"

@interface PagePhotosView (PrivateMethods)

- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;

@end

@implementation PagePhotosView
@synthesize dataSource;
@synthesize imageViews;
@synthesize bImage;

- (id)initWithFrame:(CGRect)frame withDataSource:(id<PagePhotosDataSource>)_dataSource withBImage:(UIImage*) image {
    if ((self = [super initWithFrame:frame])) {
		self.dataSource = _dataSource;

        bImage = [[UIImageView alloc]init];
        CGRect bFrame = CGRectMake(0, 0, 320, 240);
        bImage.frame = bFrame;
        [bImage setImage:image];
        [self addSubview:bImage];
        
        // Initialization UIScrollView
		int pageControlHeight = 20;
		scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - pageControlHeight)];
		pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height - pageControlHeight, frame.size.width, pageControlHeight)];
		
		[self addSubview:scrollView];
		[self addSubview:pageControl];
		
		int kNumberOfPages = [dataSource numberOfPages];
		
		// in the meantime, load the array with placeholders which will be replaced on demand
		NSMutableArray *views = [[NSMutableArray alloc] init];
		for (unsigned i = 0; i < kNumberOfPages; i++) {
			[views addObject:[NSNull null]];
		}
		self.imageViews = views;
		[views release];
		
		// a page is the width of the scroll view
		scrollView.pagingEnabled = YES;
		scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
		scrollView.showsHorizontalScrollIndicator = NO;
		scrollView.showsVerticalScrollIndicator = NO;
		scrollView.scrollsToTop = NO;
		scrollView.delegate = self;
		
		pageControl.numberOfPages = kNumberOfPages;
		pageControl.currentPage = 0;
		pageControl.backgroundColor = [UIColor blackColor];


		// pages are created on demand
		// load the visible page
		// load the page on either side to avoid flashes when the user starts scrolling
		[self loadScrollViewWithPage:0];
		[self loadScrollViewWithPage:1];
		
    }
    return self;
}

#pragma - refreshPhotoView protocol
- (void)refreshImageView
{
    [self loadScrollViewWithPage:self->pageControl.currentPage];
}

- (void)loadScrollViewWithPage:(int)page {
	int kNumberOfPages = [dataSource numberOfPages];
	
    if (page < 0) return;
    if (page >= kNumberOfPages) return;
	
    // replace the placeholder if necessary
	
    UIImageView *view = [imageViews objectAtIndex:page];
    if ((NSNull *)view == [NSNull null]) {
        view = [dataSource imageAtIndex:page];
        [imageViews replaceObjectAtIndex:page withObject:view];
    }

    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    
    double ratio = 1.0;
    double ratioH = frame.size.height/view.image.size.height;
    double ratioW = frame.size.width/view.image.size.width;
    ratio = ratioH<ratioW?ratioH:ratioW;
    ratioH = ratio;
    ratioW = ratio;
    
    
    frame.size.width = view.image.size.width * ratioW;
    frame.size.height = view.image.size.height * ratioH;
    
    frame.origin.x += (320 - frame.size.width)/2;
    frame.origin.y += (240 - frame.size.height)/2;
    
    view.frame = frame;

    
    // add the controller's view to the scroll view
    if (nil == view.superview) {
        [scrollView addSubview:view];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
	
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

- (IBAction)changePage:(id)sender {
    int page = pageControl.currentPage;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}


- (void)dealloc {
    [bImage release];
    [self.imageViews release];
	[scrollView release];
	[pageControl release];
    [super dealloc];
}



-(void)refreshData:(id<PagePhotosDataSource>)_dataSource
{
    //release views
    [bImage removeFromSuperview];
    [self.imageViews removeAllObjects];
    [scrollView release];
	[pageControl release];
    
    UIImage * image = bImage.image;
    bImage = [[UIImageView alloc]init];
    CGRect bFrame = CGRectMake(0, 0, 320, 240);
    bImage.frame = bFrame;
    [bImage setImage:image];
    [self addSubview:bImage];

    self.dataSource = _dataSource;
    // Initialization UIScrollView
    int pageControlHeight = 20;
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320.f, 240.0f)];
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 240.f, 320.f,pageControlHeight)];
    
    [self addSubview:scrollView];
    [self addSubview:pageControl];
    
    int kNumberOfPages = [dataSource numberOfPages];
    
    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *views = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < kNumberOfPages; i++) {
        [views addObject:[NSNull null]];
    }
    self.imageViews = views;
    [views release];
    
    // a page is the width of the scroll view
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    
    pageControl.numberOfPages = kNumberOfPages;
    pageControl.currentPage = 0;
    pageControl.backgroundColor = [UIColor blackColor];
    

    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
}

#pragma - touch event
-(void)setScrollerDelegate:(id)delegate
{
    scrollView.delegate = delegate;
}
-(int)getCurPage
{
    return pageControl.currentPage;
}

@end
