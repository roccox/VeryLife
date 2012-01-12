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


-(void)prepareNewProList
{

    [self.delegate finishedPrepareData];
}
-(void)prepareHotProList
{
    
    [self.delegate finishedPrepareData];    
}
-(void)prepareCatList
{
    /*
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setObject:@"cid,name" forKey:@"fields"];
    [params setObject:@"0" forKey:@"parent_cid"];
    [params setObject:@"taobao.itemcats.get" forKey:@"method"];
    
    NSData *resultData=[Utility getResultData:params];
    NSXMLParser *xmlParser=[[NSXMLParser alloc] initWithData:resultData];
    [xmlParser setDelegate:self];
    [xmlParser parse];    
     */
    [self.delegate finishedPrepareData];
}
-(void)prepareProList:(ItemCategoryModel *) selItemCat
{
    
    [self.delegate finishedPrepareData];
}
-(void)refreshData
{
    //for demo data only
    
    if(self.itemCatlist == nil)
        self.itemCatlist = [[NSMutableArray alloc]init];
    if(self.itemNewProList == nil)
        self.itemNewProList = [[NSMutableArray alloc]init];
    if(self.itemHotProList == nil)
        self.itemHotProList = [[NSMutableArray alloc]init];
    if(self.itemProlist == nil)
        self.itemProlist = [[NSMutableArray alloc]init];
    //Category
    ItemCategoryModel * oneCat = [[ItemCategoryModel alloc] init];
    oneCat.cid = @"12";
    oneCat.name = @"Women's Clothes";
    [self.itemCatlist addObject:oneCat];
    oneCat = [[ItemCategoryModel alloc] init];
    oneCat.cid = @"13";
    oneCat.name = @"Men's Clothes";
    [self.itemCatlist addObject:oneCat];
    oneCat = [[ItemCategoryModel alloc] init];
    oneCat.cid = @"14";
    oneCat.name = @"Children's Clothes";
    [self.itemCatlist addObject:oneCat];
    oneCat = [[ItemCategoryModel alloc] init];
    oneCat.cid = @"15";
    oneCat.name = @"Other's Clothes";
    [self.itemCatlist addObject:oneCat];
    
    //New Product
    ItemProductModel * onePro = [[ItemProductModel alloc]init];
    onePro.num_iid = @"21";
    onePro.title = @"New Cloth A";
    onePro.pic_url = @"";
    onePro.photo = [UIImage imageNamed:@"1933_1.jpg"];
    onePro.price = @"124";
    onePro.score = @"214";
    onePro.wap_detail_url = @"";
    onePro.item_type = @"New";
    onePro.item_EMS = @"5";
    onePro.item_postfee = @"23";
    onePro.item_express = @"Express";
    onePro.item_downShelf = @"NO";
    onePro.sell_count = @"23";
    onePro.seller_nick = @"疯狂也修女";
    [self.itemNewProList addObject:onePro];
    
    onePro = [[ItemProductModel alloc]init];
    onePro.num_iid = @"22";
    onePro.title = @"New Cloth B";
    onePro.pic_url = @"";
    onePro.photo = [UIImage imageNamed:@"1933_2.jpg"];
    onePro.price = @"112";
    onePro.score = @"24";
    onePro.wap_detail_url = @"";
    onePro.item_type = @"New";
    onePro.item_EMS = @"5";
    onePro.item_postfee = @"23";
    onePro.item_express = @"Express";
    onePro.item_downShelf = @"NO";
    onePro.sell_count = @"28";
    onePro.seller_nick = @"疯狂也修女";
    [self.itemNewProList addObject:onePro];
    
    
    onePro = [[ItemProductModel alloc]init];
    onePro.num_iid = @"23";
    onePro.title = @"New Cloth C";
    onePro.pic_url = @"";
    onePro.photo = [UIImage imageNamed:@"1933_3.jpg"];
    onePro.price = @"512";
    onePro.score = @"24";
    onePro.wap_detail_url = @"";
    onePro.item_type = @"New";
    onePro.item_EMS = @"5";
    onePro.item_postfee = @"23";
    onePro.item_express = @"Express";
    onePro.item_downShelf = @"NO";
    onePro.sell_count = @"68";
    onePro.seller_nick = @"疯狂也修女";
    [self.itemNewProList addObject:onePro];
    
    
    onePro = [[ItemProductModel alloc]init];
    onePro.num_iid = @"24";
    onePro.title = @"New Cloth D";
    onePro.pic_url = @"";
    onePro.photo = [UIImage imageNamed:@"1933_4.jpg"];
    onePro.price = @"502";
    onePro.score = @"24";
    onePro.wap_detail_url = @"";
    onePro.item_type = @"New";
    onePro.item_EMS = @"5";
    onePro.item_postfee = @"23";
    onePro.item_express = @"Express";
    onePro.item_downShelf = @"NO";
    onePro.sell_count = @"128";
    onePro.seller_nick = @"疯狂也修女";
    [self.itemNewProList addObject:onePro];

    //Hot Sale
    onePro = [[ItemProductModel alloc]init];
    onePro.num_iid = @"31";
    onePro.title = @"Hot Cloth A";
    onePro.pic_url = @"";
    onePro.photo = [UIImage imageNamed:@"1933_1.jpg"];
    onePro.price = @"124";
    onePro.score = @"214";
    onePro.wap_detail_url = @"";
    onePro.item_type = @"New";
    onePro.item_EMS = @"5";
    onePro.item_postfee = @"23";
    onePro.item_express = @"Express";
    onePro.item_downShelf = @"NO";
    onePro.sell_count = @"23";
    onePro.seller_nick = @"疯狂也修女";
    [self.itemHotProList addObject:onePro];
    
    onePro = [[ItemProductModel alloc]init];
    onePro.num_iid = @"32";
    onePro.title = @"Hot Cloth B";
    onePro.pic_url = @"";
    onePro.photo = [UIImage imageNamed:@"1933_2.jpg"];
    onePro.price = @"112";
    onePro.score = @"24";
    onePro.wap_detail_url = @"";
    onePro.item_type = @"New";
    onePro.item_EMS = @"5";
    onePro.item_postfee = @"23";
    onePro.item_express = @"Express";
    onePro.item_downShelf = @"NO";
    onePro.sell_count = @"28";
    onePro.seller_nick = @"疯狂也修女";
    [self.itemHotProList addObject:onePro];
    
    
    onePro = [[ItemProductModel alloc]init];
    onePro.num_iid = @"33";
    onePro.title = @"Hot Cloth C";
    onePro.pic_url = @"";
    onePro.photo = [UIImage imageNamed:@"1933_3.jpg"];
    onePro.price = @"512";
    onePro.score = @"24";
    onePro.wap_detail_url = @"";
    onePro.item_type = @"New";
    onePro.item_EMS = @"5";
    onePro.item_postfee = @"23";
    onePro.item_express = @"Express";
    onePro.item_downShelf = @"NO";
    onePro.sell_count = @"68";
    onePro.seller_nick = @"疯狂也修女";
    [self.itemHotProList addObject:onePro];
    
    
    onePro = [[ItemProductModel alloc]init];
    onePro.num_iid = @"34";
    onePro.title = @"Hot Cloth D";
    onePro.pic_url = @"";
    onePro.photo = [UIImage imageNamed:@"1933_4.jpg"];
    onePro.price = @"502";
    onePro.score = @"24";
    onePro.wap_detail_url = @"";
    onePro.item_type = @"New";
    onePro.item_EMS = @"5";
    onePro.item_postfee = @"23";
    onePro.item_express = @"Express";
    onePro.item_downShelf = @"NO";
    onePro.sell_count = @"128";
    onePro.seller_nick = @"疯狂也修女";
    [self.itemHotProList addObject:onePro];

    //Product List
    onePro = [[ItemProductModel alloc]init];
    onePro.num_iid = @"41";
    onePro.title = @"Cloth ~~~~~~~~";
    onePro.pic_url = @"";
    onePro.photo = [UIImage imageNamed:@"1933_1.jpg"];
    onePro.price = @"124";
    onePro.score = @"214";
    onePro.wap_detail_url = @"";
    onePro.item_type = @"New";
    onePro.item_EMS = @"5";
    onePro.item_postfee = @"23";
    onePro.item_express = @"Express";
    onePro.item_downShelf = @"NO";
    onePro.sell_count = @"23";
    onePro.seller_nick = @"疯狂也修女";
    [self.itemProlist addObject:onePro];
    
    onePro = [[ItemProductModel alloc]init];
    onePro.num_iid = @"42";
    onePro.title = @"Cloth @@@@@@@@";
    onePro.pic_url = @"";
    onePro.photo = [UIImage imageNamed:@"1933_2.jpg"];
    onePro.price = @"112";
    onePro.score = @"24";
    onePro.wap_detail_url = @"";
    onePro.item_type = @"New";
    onePro.item_EMS = @"5";
    onePro.item_postfee = @"23";
    onePro.item_express = @"Express";
    onePro.item_downShelf = @"NO";
    onePro.sell_count = @"28";
    onePro.seller_nick = @"疯狂也修女";
    [self.itemProlist addObject:onePro];
    
    
    onePro = [[ItemProductModel alloc]init];
    onePro.num_iid = @"43";
    onePro.title = @"Cloth ########";
    onePro.pic_url = @"";
    onePro.photo = [UIImage imageNamed:@"1933_3.jpg"];
    onePro.price = @"512";
    onePro.score = @"24";
    onePro.wap_detail_url = @"";
    onePro.item_type = @"New";
    onePro.item_EMS = @"5";
    onePro.item_postfee = @"23";
    onePro.item_express = @"Express";
    onePro.item_downShelf = @"NO";
    onePro.sell_count = @"68";
    onePro.seller_nick = @"疯狂也修女";
    [self.itemProlist addObject:onePro];
    
    
    onePro = [[ItemProductModel alloc]init];
    onePro.num_iid = @"44";
    onePro.title = @"Cloth $$$$$$$$";
    onePro.pic_url = @"";
    onePro.photo = [UIImage imageNamed:@"1933_4.jpg"];
    onePro.price = @"502";
    onePro.score = @"24";
    onePro.wap_detail_url = @"";
    onePro.item_type = @"New";
    onePro.item_EMS = @"5";
    onePro.item_postfee = @"23";
    onePro.item_express = @"Express";
    onePro.item_downShelf = @"NO";
    onePro.sell_count = @"128";
    onePro.seller_nick = @"疯狂也修女";
    [self.itemProlist addObject:onePro];
   
}

#pragma mark - XML Parser
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    self.currentElement=elementName;
    if([self.currentElement isEqualToString:@"item_cat"])
    {
        [SingleModel getSingleModal].itemCat = [[ItemCategoryModel alloc] init];
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //商品类别
    if(![self.currentElement compare:@"cid"])
    {
        [SingleModel getSingleModal].itemCat.cid=string;
    }
    if(![self.currentElement compare:@"name"])
    {
        [SingleModel getSingleModal].itemCat.name=string;
    }
    
//    if([SingleModel getSingleModal].isLoadProlist)
    {
        //类别下的商品
        if(![[SingleModel getSingleModal].currentElement compare:@"num_iid"])
        {
            [SingleModel getSingleModal].itemPro=[[ItemProductModel alloc] init];
            [SingleModel getSingleModal].itemPro.num_iid=string;
        }
        if(![[SingleModel getSingleModal].currentElement compare:@"title"])
        {
            [SingleModel getSingleModal].itemPro.title=string;
        }
        if(![[SingleModel getSingleModal].currentElement compare:@"pic_url"])
        {
            [SingleModel getSingleModal].itemPro.pic_url=string;
        }
        if(![[SingleModel getSingleModal].currentElement compare:@"price"])
        {
            [SingleModel getSingleModal].itemPro.price=string;
        }
        if(![[SingleModel getSingleModal].currentElement compare:@"score"])
        {
            [SingleModel getSingleModal].itemPro.score=string;
            [[SingleModel getSingleModal].itemProlist addObject:self.itemPro];
        }
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
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
}

@end
