//
//  Utility.h
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-18.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import <CommonCrypto/CommonHMAC.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netdb.h>
#import <arpa/inet.h>

@interface Utility : NSObject {
    
}

+(NSString *)createMD5:(NSString *)params;
+(NSString *)createSign:(NSMutableDictionary *)params;
+(NSString *)createPostURL:(NSMutableDictionary *)params;
+(NSString *)getCurrentDate;
+(NSData *)getResultData:(NSMutableDictionary *)params;
+(BOOL) connectedToNetwork;
+(BOOL) hostAvailable: (NSString *) theHost;
@end
