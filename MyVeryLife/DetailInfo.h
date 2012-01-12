//
//  DetailInfo.h
//  MyVeryLife
//
//  Created by Rock on 12-1-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SingleModel.h"

@interface DetailInfo : UIViewController{
    ItemProductModel * product;
}

@property(nonatomic,strong) ItemProductModel * product;

@end
