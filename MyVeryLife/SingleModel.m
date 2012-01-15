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

@synthesize currentElement;

+ (SingleModel *)getSingleModal {
    if (single == nil) {
        single = [[SingleModel alloc] init];
    }
    return single;
}



-(void)prepareProList:(ItemCategoryModel *) selItemCat
{
    
    [self.delegate finishedRefreshData];
}

-(void)getProInfo:(int)item_no
{
    _parseState = TAOBAO_PARSE_START;
    
    NSLog(@"%@",[[NSString alloc]initWithFormat:@"%d",item_no]);
    //Get Category List
    self.itemPro = [self.itemAllProList objectAtIndex:item_no];
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setObject:@"num_iid,seller_cids,num,price,express_fee,item_images,wap_desc,wap_detail_url" forKey:@"fields"];
    [params setObject:self.itemPro.num_iid forKey:@"num_iid"];
    [params setObject:@"taobao.item.get" forKey:@"method"];
    
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
    [params setObject:@"num_iid,title,volume,pic_url,location,price" forKey:@"fields"];
    [params setObject:@"podees" forKey:@"nicks"];
    [params setObject:@"volume:desc" forKey:@"order_by"];
    [params setObject:_page_num forKey:@"page_no"];
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
    else if([self.currentElement isEqualToString:@"item_get_response"])
    {
        _parseState = TAOBAO_PARSE_PRO_INFO;
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
                [SingleModel getSingleModal].itemCat.name=string;
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
                //should Assert here
            }
            else if(![self.currentElement compare:@"seller_cids"])
            {
                self.itemPro.seller_cids=string;
            }
            else if(![self.currentElement compare:@"num"])
            {
                self.itemPro.stock_num=string;
            }
            else if(![self.currentElement compare:@"express_fee"])
            {
                self.itemPro.item_express =string;
            }
            else if(![self.currentElement compare:@"wap_desc"])
            {
                self.itemPro.wap_desc=string;
            }
            else if(![self.currentElement compare:@"wap_detail_url"])
            {
                self.itemPro.wap_detail_url=string;
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
                [self.itemCatlist addObject:self.itemCat];
            }
            break;
        case TAOBAO_PARSE_PRO_LIST:
            if([elementName isEqualToString:@"item"])
            {
                [self.itemAllProList addObject:self.itemPro];
            }
            break;
            break;
        case TAOBAO_PARSE_PRO_INFO:
            break;
        default:
            break;
    }

    if([elementName isEqualToString:@"item_cat"])
    {
        [self.itemCatlist addObject:self.itemCat];
    }
    if([elementName isEqualToString:@"itemcats_get_response"])
    {
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
                [self getProductsList:[self.itemAllProList count]/40 + 1];
            else    
            {
                _item_getinfo_no = 0;
                [self getProInfo:_item_getinfo_no];
            }
            break;
        case TAOBAO_PARSE_PRO_INFO:
            _item_getinfo_no++;
            if(_item_getinfo_no == [self.itemAllProList count])
            {
                _item_getinfo_no = 0;
                [self tidyData];
                NSLog(@"finishedRefreshData - start");
                [self.delegate finishedRefreshData];
            }
            else
                [self getProInfo:_item_getinfo_no];
            break;
        default:
            break;
    }
}

-(void)tidyData
{
    //Hot Sale List - get the first 4 items
    for(int i=0;i<[itemAllProList count];i++)
    {
        [self.itemHotProList addObject:[self.itemAllProList objectAtIndex:i]];
    }
    //new Product
    for(int i=0;i<[self.itemCatlist count];i++)
    {
        ItemCategoryModel * cat = [itemCatlist objectAtIndex:i];
        if([cat.name hasSuffix:@"上新"] || [cat.name hasSuffix:@"新品"])
        {
            for(ItemProductModel * pro in itemAllProList)
            {
                if([pro.seller_cids rangeOfString:cat.cid].length > 0)
                {
                    [self.itemNewProList addObject:pro];
                    break;
                }
            }
            [itemCatlist removeObjectAtIndex:i];
            i--;
        }
    }
    
    //filter category
    //TODO:

}
@end
