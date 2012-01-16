//
//  DetailInfoWeb.h
//  MyVeryLife
//
//  Created by Rock on 12-1-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailInfoWeb : UIViewController

@property(nonatomic,strong)IBOutlet UIWebView * webView;
@property(nonatomic,strong)NSMutableURLRequest * request;
@end
