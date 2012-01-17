//
//  CommentController.h
//  MyVeryLife
//
//  Created by Rock on 12-1-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleModel.h"
#import "CommentCell.h"

@interface CommentController : UITableViewController<TaobaoDataDelegate>

@property(nonatomic,strong) NSString * num_iid;

@end
