//
//  LTNetworkCache.m
//  LTNetworkHelper
//
//  Created by Apple on 2017/10/10.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "LTNetworkCache.h"

#import "YYCache.h"

@implementation LTNetworkCache

static NSString *const LTNetworkResponseCache = @"LTNetworkResponseCache";
static YYCache *_dataCache;

+ (void)initialize
{
    _dataCache = [YYCache cacheWithName:LTNetworkResponseCache];
}

+ (void)setHttpCache:(id)httpData URL:(NSString *)URL parameters:(NSDictionary *)parameters {
    
    NSString *cacheKey = [self cacheWithUrl:URL parameters:parameters];
    //异步缓存数据，不会阻塞主线程
    [_dataCache setObject:httpData forKey:cacheKey withBlock:nil];
    
}
+ (id) httpCacheWithUrl:(NSString *)url parameters:(NSDictionary *)parameters {
    NSString *cackeKey = [self cacheWithUrl:url parameters:parameters];
    return [_dataCache objectForKey:cackeKey];
}

+ (NSInteger)getAllHttpCacheSzie {
    return [_dataCache.diskCache totalCost];
}

+ (void)removeAllHttpCache {
    [_dataCache.diskCache removeAllObjects];
}

+ (NSString *)cacheWithUrl:(NSString *)url parameters:(NSDictionary *)parameters {
    if (!parameters || parameters.count == 0) {
        return url;
    }
    NSData *stringData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    NSString *paraString = [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
    NSString *cacheKey = [NSString stringWithFormat:@"%@%@",url,paraString];
    return [NSString stringWithFormat:@"%ld",cacheKey.hash];
}


@end