//
//  VPHybridCache.h
//  Pods
//
//  Created by gangpeng shu on 2017/6/2.
//
//

#import <Foundation/Foundation.h>


@interface VPHybridCache : NSObject

/**
 获取磁盘中的缓存的大小
 
 @return long long 单位:byte
 */
+ (long long)getCacheSize;

/**
 清理磁盘的缓存
 */
+ (void)cleanCache;

@end
