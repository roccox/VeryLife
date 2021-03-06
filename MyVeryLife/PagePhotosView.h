//
//  PagePhotosView.h
//  PagePhotosDemo
//
//  Created by Andy soonest on 11-11-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagePhotosDataSource.h"
#import "UIScrollView+TouchScroll.h"

#import "ItemProductModel.h"
@interface PagePhotosView : UIView<UIScrollViewDelegate,PagePhotosRefresh> {
    UIImageView * bImage;
	UIScrollView *scrollView;
	UIPageControl *pageControl;
	
	id<PagePhotosDataSource> dataSource;
	NSMutableArray *imageViews;
	
	// To be used when scrolls originate from the UIPageControl
    BOOL pageControlUsed;
}

@property(nonatomic,retain) UIImageView * bImage;
@property (nonatomic, assign) id<PagePhotosDataSource> dataSource;
@property (nonatomic, retain) NSMutableArray *imageViews;

- (IBAction)changePage:(id)sender;

- (id)initWithFrame:(CGRect)frame withDataSource:(id<PagePhotosDataSource>)_dataSource withBImage:(UIImage*) image;

-(void)refreshData:(id<PagePhotosDataSource>)_dataSource;

-(void)setScrollerDelegate:(id)delegate;
-(int)getCurPage;

@end
