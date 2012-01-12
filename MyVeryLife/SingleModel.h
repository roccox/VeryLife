//
//  SingleModel.h
//  MyVeryLife
//
//  Created by Rock on 12-1-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemCategoryModel.h"
#import "ItemProductModel.h"
#import "Utility.h"

typedef enum{
    TAOBAO_PARSE_CAT,
    TAOBAO_PARSE_PRO_LIST,
    TAOBAO_PARSE_PRO
}TaobaoPraseState;

@protocol TaobaoDataDelegate;
@interface SingleModel : NSObject <NSXMLParserDelegate> {
    __unsafe_unretained id _delegate;
    ItemCategoryModel * itemCat;                 //当前选中类型
    ItemProductModel * itemPro;                  //当前产品
    NSMutableArray * itemCatlist;                //产品全部类型列表
    NSMutableArray * itemProlist;                //当前类型产品列表
    NSMutableArray * itemNewProList;             //上新产品
    NSMutableArray * itemHotProList;     //掌柜推荐产品
    
    NSString * currentElement;
}

@property(nonatomic,unsafe_unretained)id<TaobaoDataDelegate> delegate;
@property(nonatomic,retain)ItemCategoryModel * itemCat;
@property(nonatomic,retain)ItemProductModel * itemPro;
@property(nonatomic,retain)NSMutableArray * itemCatlist;
@property(nonatomic,retain)NSMutableArray * itemProlist;
@property(nonatomic,strong)NSMutableArray * itemNewProList;
@property(nonatomic,strong)NSMutableArray * itemHotProList;

@property(nonatomic,strong)NSString * currentElement;

+ (SingleModel *)getSingleModal;
-(void)prepareNewProList;
-(void)prepareHotProList;
-(void)prepareCatList;
-(void)prepareProList:(ItemCategoryModel *) selItemCat;
-(void)refreshData;


@end

@protocol TaobaoDataDelegate

-(void) finishedPrepareData;
@end
