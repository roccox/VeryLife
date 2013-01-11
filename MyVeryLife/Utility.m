//
//  Utility.m
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-18.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import "Utility.h"


@implementation Utility
+(NSString *)createMD5:(NSString *)signString
{
    const char*cStr =[signString UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result);
    return[NSString stringWithFormat:
           @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
           result[0], result[1], result[2], result[3],
           result[4], result[5], result[6], result[7],
           result[8], result[9], result[10], result[11],
           result[12], result[13], result[14], result[15]
           ];
}

+(NSString *)createSign:(NSMutableDictionary *)params
{
    NSArray *keys=[params allKeys];
    keys=[keys sortedArrayUsingSelector:@selector(compare:)];
    
    NSString *signData=[[[NSString alloc] init] autorelease];
    signData=[signData stringByAppendingFormat:APP_SECRET];
    for(NSString *key in keys)
    {
        signData=[signData stringByAppendingFormat:@"%@%@",key,[params objectForKey:key]];
    }
    signData=[signData stringByAppendingFormat:APP_SECRET];
    return [self createMD5:signData];
}

+(NSString *)createSign2:(NSMutableDictionary *)params
{
    NSArray *keys=[params allKeys];
    keys=[keys sortedArrayUsingSelector:@selector(compare:)];
    
    NSString *signData=[[[NSString alloc] init] autorelease];
    signData=[signData stringByAppendingFormat:APP_SECRET2];
    for(NSString *key in keys)
    {
        signData=[signData stringByAppendingFormat:@"%@%@",key,[params objectForKey:key]];
    }
    signData=[signData stringByAppendingFormat:APP_SECRET2];
    return [self createMD5:signData];
}


+(NSString *)createPostURL:(NSMutableDictionary *)params
{
    NSString *postString=@"";
    for(NSString *key in [params allKeys])
    {
        NSString *value=[params objectForKey:key];
        postString=[postString stringByAppendingFormat:@"%@=%@&",key,value];
    }
    if([postString length]>1)
    {
        postString=[postString substringToIndex:[postString length]-1];
    }
    return postString;
}

+(NSString *)getCurrentDate
{
    NSDateFormatter *dateFormatter=[[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

+(NSData *)getResultData:(NSMutableDictionary *)params
{
    [params setObject:APP_KEY forKey:@"app_key"];
    [params setObject:@"xml" forKey:@"format"];
    [params setObject:@"md5" forKey:@"sign_method"];
    [params setObject:[Utility getCurrentDate] forKey:@"timestamp"];
    [params setObject:@"2.0" forKey:@"v"];
    [params setObject:[Utility createSign:params] forKey:@"sign"];
    
    NSString *postURL=[Utility createPostURL:params];
    NSError *error;
    NSURLResponse *theResponse;
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:BASEURL]];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:[postURL dataUsingEncoding:NSUTF8StringEncoding]];
    [theRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    return [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&error];
}

+(NSData *)getResultData2:(NSMutableDictionary *)params
{
    [params setObject:APP_KEY2 forKey:@"app_key"];
    [params setObject:@"xml" forKey:@"format"];
    [params setObject:@"md5" forKey:@"sign_method"];
    [params setObject:[Utility getCurrentDate] forKey:@"timestamp"];
    [params setObject:@"2.0" forKey:@"v"];
    [params setObject:[Utility createSign2:params] forKey:@"sign"];
    
    NSString *postURL=[Utility createPostURL:params];
    NSError *error;
    NSURLResponse *theResponse;
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:BASEURL]];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:[postURL dataUsingEncoding:NSUTF8StringEncoding]];
    [theRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    return [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&error];
}


+(BOOL) connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);    
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags) 
    {
        printf("Error. Could not recover network reachability flags\n");
        return NO;
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}

// Direct from Apple. Thank you Apple
+ (BOOL)addressFromString:(NSString *)IPAddress address:(struct sockaddr_in *)address
{
    if (!IPAddress || ![IPAddress length]) return NO;
	
    memset((char *) address, sizeof(struct sockaddr_in), 0);
    address->sin_family = AF_INET;
    address->sin_len = sizeof(struct sockaddr_in);
	
    int conversionResult = inet_aton([IPAddress UTF8String], &address->sin_addr);
    if (conversionResult == 0) {
		NSAssert1(conversionResult != 1, @"Failed to convert the IP address string into a sockaddr_in: %@", IPAddress);
        return NO;
    }
	
    return YES;
}

+ (NSString *) getIPAddressForHost: (NSString *) theHost
{
    theHost=[theHost substringFromIndex:7];
    NSLog(@"%@",theHost);
	struct hostent *host = gethostbyname([theHost UTF8String]);
    if (!host) {herror("resolv"); return NULL; }
	struct in_addr **list = (struct in_addr **)host->h_addr_list;
	NSString *addressString = [NSString stringWithCString:inet_ntoa(*list[0]) encoding:NSUTF8StringEncoding];
	return addressString;
}


+ (BOOL) hostAvailable: (NSString *) theHost
{
	
    NSString *addressString = [self getIPAddressForHost:theHost];
    if (!addressString)
    {
        printf("Error recovering IP address from host name\n");
        return NO;
    }
	
    struct sockaddr_in address;
    BOOL gotAddress = [self addressFromString:addressString address:&address];
	
    if (!gotAddress)
    {
		printf("Error recovering sockaddr address from %s\n", [addressString UTF8String]);
        return NO;
    }
	
	SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&address);
    SCNetworkReachabilityFlags flags;
	
	BOOL didRetrieveFlags =SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
	
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flags\n");
        return NO;
    }
	
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    return isReachable ? YES : NO;;
}

@end
