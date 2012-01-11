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

@interface HomeTabController : UITableViewController <PagePhotosDataSource>

@property (strong,nonatomic) PagePhotosView * pagePhotoView;
@end
