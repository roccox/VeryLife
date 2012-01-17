//
//  CommentCell.h
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-23.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CommentCell : UITableViewCell {
    IBOutlet UILabel *item_content;
    IBOutlet UILabel *item_create;
    IBOutlet UILabel *item_nick;
}

@property(nonatomic,retain)IBOutlet UILabel *item_content;
@property(nonatomic,retain)IBOutlet UILabel *item_create;
@property(nonatomic,retain)IBOutlet UILabel *item_nick;
@end
