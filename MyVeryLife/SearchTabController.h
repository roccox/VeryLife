//
//  SearchTabController.h
//  MyVeryLife
//
//  Created by Rock on 12-1-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageManagerDelegate.h"
#import "SDWebImageDownloaderDelegate.h"

#import "DetailInfo.h"
#import "SingleModel.h"

#import "Utility.h"

@interface SearchTabController :  UITableViewController <TaobaoDataDelegate,SDWebImageManagerDelegate,SDWebImageDownloaderDelegate>


-(void)refreshData;
- (IBAction) sortBySellcount;
-(IBAction)sortByDate;
@end
