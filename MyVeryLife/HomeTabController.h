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

#import "SingleModel.h"

#import "Utility.h"

@interface HomeTabController : UITableViewController <PagePhotosDataSource,NSXMLParserDelegate,TaobaoDataDelegate>{

}

@property (strong,nonatomic) PagePhotosView * pagePhotoView;

-(void)getRecommendedProInfo;
-(void)getNewProInfo;

-(void)refreshData;

@end
