//
//  ProductCell.h
//  MyVeryLife
//
//  Created by Rock on 12-2-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCell : UITableViewCell{
    UIImageView * myImage;
    UILabel     * title;
    UILabel     * price;
    UILabel     * freight;
    UILabel     * sold;
}
@property(strong,nonatomic)IBOutlet UIImageView * myImage;
@property(strong,nonatomic)IBOutlet UILabel     * title;
@property(strong,nonatomic)IBOutlet UILabel     * price;
@property(strong,nonatomic)IBOutlet UILabel     * freight;
@property(strong,nonatomic)IBOutlet UILabel     * sold;


@end