//
//  StartViewController.h
//  MyVeryLife
//
//  Created by Rock on 12-3-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DetailInfo.h"
#import "SingleModel.h"

#import "Utility.h"

@interface StartViewController : UIViewController <TaobaoDataDelegate>



@property(nonatomic,strong) IBOutlet UITextView * status;

-(void)getData;
-(IBAction)goBtn:(id)sender;
@end
