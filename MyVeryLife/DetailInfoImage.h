//
//  DetailInfoImage.h
//  MyVeryLife
//
//  Created by Rock on 12-1-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDWebImageManagerDelegate.h"
#import "SDWebImageDownloaderDelegate.h"

@interface DetailInfoImage : UIViewController<SDWebImageManagerDelegate,SDWebImageDownloaderDelegate>{
    UIImageView * imageView;
}

@property(strong,nonatomic)IBOutlet UIImageView * imageView;
@property(nonatomic,strong)NSURL *url;
@end
