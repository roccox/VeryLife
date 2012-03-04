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
#import "CommentModel.h"

typedef enum{
    TAOBAO_PARSE_START,
    TAOBAO_PARSE_CAT,
    TAOBAO_PARSE_PRO_LIST,
    TAOBAO_PARSE_PRO_INFO,
    TAOBAO_PARSE_DETAIL_INFO,
    TAOBAO_PARSE_COMMENT
}TaobaoPraseState;

@protocol TaobaoDataDelegate;
@interface SingleModel : NSObject <NSXMLParserDelegate> {
    __unsafe_unretained id _delegate;
    ItemCategoryModel * itemCat;                 //当前选中类型
    ItemProductModel * itemPro;                  //当前产品
    CommentModel * itemComment;
    
    NSMutableArray * itemCatlist;                //产品全部类型列表
    NSMutableArray * itemAllProList;             //当前用户全部产品
    NSMutableArray * itemProlist;                //当前类型产品列表
    NSMutableArray * itemNewProList;             //上新产品
    NSMutableArray * itemHotProList;     //掌柜推荐产品
    NSMutableArray * itemCommentList;
    
    TaobaoPraseState _parseState;               //XML Parse status
    int _item_total_count;                  //全部产品数量
    int _item_getinfo_no;                   //当前获取的产品序号
    
    NSString * currentElement;

}

@property(nonatomic,unsafe_unretained)id<TaobaoDataDelegate> delegate;
@property(nonatomic,retain)ItemCategoryModel * itemCat;
@property(nonatomic,retain)ItemProductModel * itemPro;
@property(nonatomic,retain)NSMutableArray * itemCatlist;
@property(nonatomic,retain)NSMutableArray * itemAllProList;
@property(nonatomic,retain)NSMutableArray * itemProlist;
@property(nonatomic,strong)NSMutableArray * itemNewProList;
@property(nonatomic,strong)NSMutableArray * itemHotProList;
@property(nonatomic,strong)NSMutableArray * itemCommentList;

@property(nonatomic,strong)NSString * currentElement;

+ (SingleModel *)getSingleModal;
-(void)prepareProList:(ItemCategoryModel *) selItemCat;
-(void)getProDetailInfo:(ItemProductModel *)item;
-(void)getProInfo:(int) page_no;
-(void)refreshData:(BOOL) force;
-(void)getProductsList:(int) page_no;
-(void)tidyData;

-(void)sortByDate;
-(void)sortBySellCount;
-(void)getComment:(NSString *) num_iid;
-(void)clearComment;
@end

@protocol TaobaoDataDelegate
@optional
-(void) finishedCommentData;
-(void) finishedRefreshData;
-(void) finishedDetailData;
@end
