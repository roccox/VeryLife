//
//  FirstViewController.h
//  MyVeryLife
//
//  Created by Rock on 12-1-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PagePhotosView.h"
#import "PagePhotosDataSource.h"

#import "SDWebImageManagerDelegate.h"
#import "SDWebImageDownloaderDelegate.h"

#import "DetailInfo.h"
#import "SingleModel.h"

#import "Utility.h"

#import "EGORefreshTableHeaderView.h"


@interface HomeTabController : UITableViewController <PagePhotosDataSource,TaobaoDataDelegate,SDWebImageManagerDelegate,SDWebImageDownloaderDelegate,EGORefreshTableHeaderDelegate>{

}
@property (strong, nonatomic) EGORefreshTableHeaderView *refreshHeaderView;
@property (strong,nonatomic) PagePhotosView * pagePhotoView;
@property(strong,nonatomic)NSDate * updateDate;
@property(assign,nonatomic)BOOL reLoading;

-(void)getRecommendedProInfo;
-(void)getNewProInfo;

-(void)refreshData;


- (void)doneLoadingTableViewData;
@end
