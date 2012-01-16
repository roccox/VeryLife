//
//  ProductTabProController.h
//  MyVeryLife
//
//  Created by Rock on 12-1-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleModel.h"
#import "DetailInfo.h"
#import "SDWebImageManagerDelegate.h"
#import "SDWebImageDownloaderDelegate.h"

@interface ProductTabProController : UITableViewController{
    ItemCategoryModel * cat;
}

@property(strong,nonatomic) ItemCategoryModel * cat;
@end
