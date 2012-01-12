//
//  CommentModel.h
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-23.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CommentModel : NSObject {
    
}

@property(nonatomic,retain)NSString *content;
@property(nonatomic,retain)NSString *created;
@property(nonatomic,retain)NSString *item_price;
@property(nonatomic,retain)NSString *item_title;
@property(nonatomic,retain)NSString *nick;
@property(nonatomic,retain)NSString *rated_nick;
@property(nonatomic,retain)NSString *result;
@property(nonatomic,retain)NSString *tid;
@end
