//
//  AppDelegate.h
//  MyVeryLife
//
//  Created by Rock on 12-1-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface AppDelegate : UIResponder <UIApplicationDelegate>{

}

@property (strong, nonatomic) UIWindow *window;
@property(assign,nonatomic) BOOL refreshHomeTab;
@property(assign,nonatomic) BOOL refreshProTab;
@property(strong,nonatomic) NSThread * curThread;


@end
