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

#import "ProductCell.h"

@interface SearchTabController :  UITableViewController <TaobaoDataDelegate,SDWebImageManagerDelegate,SDWebImageDownloaderDelegate,UISearchBarDelegate>{
    NSMutableArray * filterList;
    UISearchBar * searchBar;
    BOOL isFilted;
}

@property(strong,nonatomic) NSMutableArray * filterList;
@property(strong,nonatomic) IBOutlet UISearchBar * searchBar;

-(void)refreshData;

@end
