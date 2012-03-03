//
//  DetailInfo.h
//  MyVeryLife
//
//  Created by Rock on 12-1-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SingleModel.h"
#import "PagePhotosView.h"
#import "PagePhotosDataSource.h"

#import "UIScrollView+TouchScroll.h"

#import "SDWebImageManagerDelegate.h"
#import "SDWebImageDownloaderDelegate.h"

@interface DetailInfo : UIViewController<PagePhotosDataSource,SDWebImageManagerDelegate,SDWebImageDownloaderDelegate,UIScrollViewDelegate,TaobaoDataDelegate>{
    ItemProductModel * product;
    
    UILabel * titleLabel;
    UILabel * priceLabel;
    UILabel * sellCountLabel;
    UILabel * proTypeLabel;
    UILabel * locationLabel;
    
    UILabel * colorLabel;
    UILabel * sizeLabel;
    
    UIButton * commentBtn;
    UIButton * buyBtn;
    
    UIScrollView  * scrollView;
    
    PagePhotosView * pagePhotoView;
    
}

@property(nonatomic,strong) ItemProductModel * product;

@property(nonatomic,strong)IBOutlet  UILabel * titleLabel;
@property(nonatomic,strong)IBOutlet  UILabel * priceLabel;
@property(nonatomic,strong)IBOutlet  UILabel * sellCountLabel;
@property(nonatomic,strong)IBOutlet  UILabel * proTypeLabel;
@property(nonatomic,strong)IBOutlet UILabel * locationLabel;

@property(nonatomic,strong)IBOutlet  UILabel * colorLabel;
@property(nonatomic,strong)IBOutlet  UILabel * sizeLabel;


@property(nonatomic,strong)UIButton * commentBtn;
@property(nonatomic,strong)UIButton * buyBtn;
@property(nonatomic,strong)IBOutlet UITextView * desc;

@property(nonatomic,strong)IBOutlet UIScrollView * scrollView;

@property(nonatomic,strong) UIActivityIndicatorView * waitingView;

@property(nonatomic,strong) PagePhotosView * pagePhotoView;

- (IBAction)commentBtnClicked;
- (IBAction)buyBtnClicked;
-(void) dataReady;
-(void)getData;
@end
