//
//  SingleModel.m
//  MyVeryLife
//
//  Created by Rock on 12-1-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SingleModel.h"

static SingleModel *single = nil;

@implementation SingleModel

@synthesize delegate = _delegate;
@synthesize itemCat;
@synthesize itemPro;
@synthesize itemCatlist;
@synthesize itemAllProList;
@synthesize itemProlist;
@synthesize itemNewProList;
@synthesize itemHotProList;
@synthesize itemCommentList;

@synthesize currentElement;

+ (SingleModel *)getSingleModal {
    if (single == nil) {
        single = [[SingleModel alloc] init];
    }
    return single;
}

-(void)sortByDate
{
    
}

-(void)sortBySellCount
{
    ItemProductModel * iPro, *jPro;
    NSMutableArray * tmpList = [[NSMutableArray alloc]init];
    for(int i=0;i<[itemAllProList count];i++)
    {
        iPro = [itemAllProList objectAtIndex:i];
        for(int j=i+1;j<[itemAllProList count];j++)
        {
            jPro = [itemAllProList objectAtIndex:j];
            if([iPro.sell_count intValue] < [jPro.sell_count intValue])
                iPro = jPro;
        }
        [tmpList addObject:iPro];
    }
    itemAllProList = tmpList;
}


-(void)prepareProList:(ItemCategoryModel *) selItemCat
{
    [itemProlist removeAllObjects];
    NSMutableArray * childCat = [[NSMutableArray alloc]initWithCapacity:4];
    //search child cat
    for(ItemCategoryModel * cat in itemCatlist)
    {
        if([cat.parent_id compare:selItemCat.cid] == NSOrderedSame)
            [childCat addObject:cat];
    }
    
    for(ItemProductModel * pro in itemAllProList)
    {
        if([pro.seller_cids rangeOfString:selItemCat.cid].length >0)
            [itemProlist addObject:pro];
        else
        {
            for(ItemCategoryModel * cat in childCat)
            {
                if([pro.seller_cids rangeOfString:cat.cid].length >0)
                {
                    [itemProlist addObject:pro];                
                    continue;
                }
            }
        }
    }
}

-(void)getProDetailInfo:(ItemProductModel *)item
{
    _parseState = TAOBAO_PARSE_START;
    
    //Get Category List
    self.itemPro = item;
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    //wap_desc
    [params setObject:@"num_iid,num,price,express_fee,item_images,desc,wap_detail_url" forKey:@"fields"];
    [params setObject:self.itemPro.num_iid forKey:@"num_iid"];
    [params setObject:@"taobao.item.get" forKey:@"method"];
    
    NSData *resultData=[Utility getResultData:params];
    NSXMLParser *xmlParser=[[NSXMLParser alloc] initWithData:resultData];
    [xmlParser setDelegate:self];
    [xmlParser parse];    
    
}

-(void)getProInfo:(int)page_no
{
    _parseState = TAOBAO_PARSE_START;
    
    //Get Category List
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setObject:@"num_iid,seller_cids,list_time" forKey:@"fields"];
    NSString * iid = @"";
    ItemProductModel * pro;
    for(int i = page_no*20; i< self.itemAllProList.count && i< (page_no+1)*20;i++)
    {
        pro = [self.itemAllProList objectAtIndex:i];
        iid = [iid stringByAppendingFormat:@"%@,",pro.num_iid];
    }
    [params setObject:iid forKey:@"num_iids"];
    [params setObject:@"taobao.items.list.get" forKey:@"method"];
    
    NSData *resultData=[Utility getResultData:params];
    NSXMLParser *xmlParser=[[NSXMLParser alloc] initWithData:resultData];
    [xmlParser setDelegate:self];
    [xmlParser parse];    
    
}

-(void)clearComment
{
    [itemCommentList removeAllObjects];    
}

-(void)getComment:(NSString *) num_iid
{
    _parseState = TAOBAO_PARSE_START;
    
    [itemCommentList removeAllObjects];

    //Get Category List
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setObject:num_iid forKey:@"num_iid"];
    [params setObject:@"podees" forKey:@"seller_nick"];
    [params setObject:@"40" forKey:@"page_size"];
    [params setObject:@"taobao.traderates.search" forKey:@"method"];
    
    NSData *resultData=[Utility getResultData:params];
    NSXMLParser *xmlParser=[[NSXMLParser alloc] initWithData:resultData];
    [xmlParser setDelegate:self];
    [xmlParser parse];    
}

-(void) getProductsList:(int)page_no
{
    _parseState = TAOBAO_PARSE_START;
    
    //Get Category List
    NSString * _page_num = [[NSString alloc]initWithFormat:@"%d",page_no];
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setObject:@"num_iid,title,volume,pic_url,location,price,stuff_status" forKey:@"fields"];
    [params setObject:@"podees" forKey:@"nicks"];
    [params setObject:@"volume:desc" forKey:@"order_by"];
    [params setObject:_page_num forKey:@"page_no"];
    [params setObject:@"volume:desc" forKey:@"order_by"];
    [params setObject:@"taobao.items.get" forKey:@"method"];
    
    NSData *resultData=[Utility getResultData:params];
    NSXMLParser *xmlParser=[[NSXMLParser alloc] initWithData:resultData];
    [xmlParser setDelegate:self];
    [xmlParser parse];    

}

-(void)refreshData:(BOOL) force
{
    //Init Data list
    if(self.itemCatlist == nil)
        self.itemCatlist = [[NSMutableArray alloc]init];
    if(self.itemAllProList == nil)
        self.itemAllProList = [[NSMutableArray alloc]init];
    if(self.itemNewProList == nil)
        self.itemNewProList = [[NSMutableArray alloc]init];
    if(self.itemHotProList == nil)
        self.itemHotProList = [[NSMutableArray alloc]init];
    if(self.itemProlist == nil)
        self.itemProlist = [[NSMutableArray alloc]init];
    if(itemCommentList == nil)
        itemCommentList = [[NSMutableArray alloc]init];

    //TODO: check the itemNewProList
    
    _parseState = TAOBAO_PARSE_START;

    //Get Category List
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setObject:@"cid,name,parent_cid" forKey:@"fields"];
    [params setObject:@"podees" forKey:@"nick"];
    [params setObject:@"taobao.sellercats.list.get" forKey:@"method"];
    
    NSData *resultData=[Utility getResultData:params];
    NSXMLParser *xmlParser=[[NSXMLParser alloc] initWithData:resultData];
    [xmlParser setDelegate:self];
    [xmlParser parse];    
}

#pragma mark - XML Parser
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    self.currentElement=elementName;

    if([self.currentElement isEqualToString:@"sellercats_list_get_response"])
    {
        _parseState = TAOBAO_PARSE_CAT;
    }
    else if([self.currentElement isEqualToString:@"seller_cat"])
    {
        [SingleModel getSingleModal].itemCat = [[ItemCategoryModel alloc] init];
    }
    else if([self.currentElement isEqualToString:@"items_get_response"])
    {
        _parseState = TAOBAO_PARSE_PRO_LIST;
    }
    else if([self.currentElement isEqualToString:@"item"] && _parseState==TAOBAO_PARSE_PRO_LIST)
    {
        [SingleModel getSingleModal].itemPro = [[ItemProductModel alloc] init];
    }
    else if([self.currentElement isEqualToString:@"items_list_get_response"])
    {
        _parseState = TAOBAO_PARSE_PRO_INFO;
    }
    else if([self.currentElement isEqualToString:@"item_get_response"])
    {
        _parseState = TAOBAO_PARSE_DETAIL_INFO;
    }
    else if([self.currentElement isEqualToString:@"traderates_search_response"])
    {
        _parseState = TAOBAO_PARSE_COMMENT;
    }
    else if([self.currentElement isEqualToString:@"trade_rate"])
    {
        itemComment = [[CommentModel alloc]init];
    }
    
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    switch (_parseState) {
        case TAOBAO_PARSE_CAT:
            //商品类别
            if(![self.currentElement compare:@"cid"])
            {
                [SingleModel getSingleModal].itemCat.cid=string;
            }
            else if(![self.currentElement compare:@"name"])
            {
                if([[SingleModel getSingleModal].itemCat.name length] ==0)
                    [SingleModel getSingleModal].itemCat.name=string;
                else
                    [SingleModel getSingleModal].itemCat.name = [[SingleModel getSingleModal].itemCat.name stringByAppendingFormat:@"%@",string];
            }
            else if(![self.currentElement compare:@"parent_cid"])
            {
                [SingleModel getSingleModal].itemCat.parent_id=string;
            }
            break;
        case TAOBAO_PARSE_PRO_LIST:
            //商品列表
            if(![self.currentElement compare:@"num_iid"])
            {
                [SingleModel getSingleModal].itemPro.num_iid=string;
            }
            else if(![self.currentElement compare:@"title"])
            {
                [SingleModel getSingleModal].itemPro.title=string;
            }
            else if(![self.currentElement compare:@"volume"])
            {
                [SingleModel getSingleModal].itemPro.sell_count=string;
            }
            else if(![self.currentElement compare:@"pic_url"])
            {
                [SingleModel getSingleModal].itemPro.pic_url=string;
            }
            else if(![self.currentElement compare:@"city"])
            {
                [SingleModel getSingleModal].itemPro.location=string;
            }
            else if(![self.currentElement compare:@"price"])
            {
                [SingleModel getSingleModal].itemPro.price=string;
            }
            else if(![self.currentElement compare:@"total_results"])
            {
                _item_total_count=[string intValue];
            }
            break;
        case TAOBAO_PARSE_PRO_INFO:
            //商品信息
            if(![self.currentElement compare:@"num_iid"])
            {
                //search itemPro
                ItemProductModel * pro;
                for(int i=0;i<[self.itemAllProList count];i++)
                {
                    pro = [self.itemAllProList objectAtIndex:i];
                    if([pro.num_iid isEqualToString: string])
                        self.itemPro = pro;
                }

            }
            else if(![self.currentElement compare:@"seller_cids"])
            {
                self.itemPro.seller_cids=string;
            }
            else if(![self.currentElement compare:@"list_time"])
            {
                self.itemPro.list_time=string;
            }
            break;
        case TAOBAO_PARSE_DETAIL_INFO:
            //商品信息
            if(![self.currentElement compare:@"num"])
            {
                self.itemPro.stock_num=string;
            }
            else if(![self.currentElement compare:@"express_fee"])
            {
                self.itemPro.item_express =string;
            }
            else if(![self.currentElement compare:@"desc"])//wap_desc
            {
                NSString * _pro = [SingleModel getSingleModal].itemPro.wap_desc;
                if([_pro length] ==0)
                    _pro=string;
                else
                {
//                    _pro = @"t\n";
//                    _pro = [_pro stringByAppendingString: @"t\n"];
//                    _pro = [_pro stringByAppendingString:@"\n"];
                    _pro = [_pro stringByAppendingFormat:@"%@",string];   
                }
                
                [SingleModel getSingleModal].itemPro.wap_desc = _pro;
            }
            else if(![self.currentElement compare:@"wap_detail_url"])
            {
                self.itemPro.wap_detail_url=string;
            }
            else if(![self.currentElement compare:@"stuff_status"])
            {
                self.itemPro.item_type=string;
            }
            
            break;
        case TAOBAO_PARSE_COMMENT:
            //评价信息
            if([self.currentElement isEqualToString:@"content"])
            {
                itemComment.content=string;
            }
            if([self.currentElement isEqualToString:@"created"])
            {
                itemComment.created=string;
            }
            if([self.currentElement isEqualToString:@"nick"])
            {
                itemComment.rated_nick=string;
            }
            if([self.currentElement isEqualToString:@"result"])
            {
                itemComment.result=string;
            }
            break;
        default:
            break;
    }
    
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    switch (_parseState) {
        case TAOBAO_PARSE_CAT:
            //商品类别
            if([elementName isEqualToString:@"seller_cat"])
            {
                BOOL isExist = NO;
                for( ItemCategoryModel * cat in self.itemCatlist)
                {
                    if([cat.cid compare: self.itemCat.cid] == NSOrderedSame)
                    {
                        isExist = YES;
                        break;
                    }
                    
                }
                if(!isExist)
                    [self.itemCatlist addObject:self.itemCat];
            }
            break;
        case TAOBAO_PARSE_PRO_LIST:
            if([elementName isEqualToString:@"item"])
            {
                /* taobao send duplicated data in different pages
                BOOL isExist = NO;
                for( ItemProductModel * pro in self.itemAllProList)
                {
                    if([pro.num_iid compare: self.itemPro.num_iid]  == NSOrderedSame)
                    {
                        isExist = YES;
                        break;
                    }
                    
                }
                if(!isExist)
                 */
                    [self.itemAllProList addObject:self.itemPro];
            }
            break;
        case TAOBAO_PARSE_PRO_INFO:
            break;
        case TAOBAO_PARSE_DETAIL_INFO:
            break;
        case TAOBAO_PARSE_COMMENT:
            if([elementName isEqualToString:@"trade_rate"])
            {
                [self.itemCommentList addObject:itemComment];
            }
            break;
        default:
            break;
    }

}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    //Pase Ended, start to tidy and sord
    switch (_parseState) {
        case TAOBAO_PARSE_CAT:
            //start to get all product list
            [self getProductsList:1];
            break;
        case TAOBAO_PARSE_PRO_LIST:
            if([self.itemAllProList count] < _item_total_count)
            {
                NSLog(@"count= %d",[self.itemAllProList count]);
                [self getProductsList:[self.itemAllProList count]/40 + 1];
            }
            else
            {
                _item_getinfo_no = 0;
                [self getProInfo:_item_getinfo_no];
            }
            break;
        case TAOBAO_PARSE_PRO_INFO:
            _item_getinfo_no++;
            if(_item_getinfo_no * 20 >= [self.itemAllProList count])
            {
                _item_getinfo_no = 0;
                [self tidyData];
                NSLog(@"finishedRefreshData - start");
                [self.delegate finishedRefreshData];
            }
            else
                [self getProInfo:_item_getinfo_no];
            break;
        case TAOBAO_PARSE_DETAIL_INFO:
            [self.delegate finishedDetailData];
            break;
        case TAOBAO_PARSE_COMMENT:
            [self.delegate finishedCommentData];
            break;
        default:
            break;
    }
}

-(void)tidyData
{
    BOOL isExist = NO;
    ItemProductModel * newPro;
    //Hot Sale List - get the first 4 items
    for(int i=0;i<[itemAllProList count] && i<=10;i++)
    {
        newPro = [self.itemAllProList objectAtIndex:i];
        isExist = NO;
        for( ItemProductModel * pro in self.itemHotProList)
        {
            if([pro.num_iid compare: newPro.num_iid] == NSOrderedSame)
            {
                isExist = YES;
                break;
            }
            
        }
        if(!isExist)
            [self.itemHotProList addObject:newPro];
    }
    //new Product
    for(int i=0;i<[self.itemCatlist count];i++)
    {
        ItemCategoryModel * cat = [itemCatlist objectAtIndex:i];
        if([cat.name isEqualToString:@"产品种类"] || [cat.name isEqualToString:@"品牌"])
        {
            [itemCatlist removeObjectAtIndex:i];
            i--;
            continue;
        }
        if([cat.name hasPrefix:@"※"])
        {
            for(ItemProductModel * pro in itemAllProList)
            {
                if([pro.seller_cids rangeOfString:cat.cid].length > 0)
                {
                    isExist = NO;
                    for( ItemProductModel * _pro in self.itemNewProList)
                    {
                        if([pro.num_iid compare: _pro.num_iid] == NSOrderedSame)
                        {
                            isExist = YES;
                            break;
                        }
                        
                    }
                    if(!isExist)
                        [self.itemNewProList addObject:pro];
                    continue;
                }
            }
//            [itemCatlist removeObjectAtIndex:i];
//            i--;
        }
    }
    
    //filter category
    //TODO:

}
@end
