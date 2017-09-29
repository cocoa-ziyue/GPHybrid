//
//  NSString+md5.h
//  Pods
//
//  Created by Jia Yuanfa on 2017/3/24.
//
//

#import <Foundation/Foundation.h>


@interface NSString (Hybridmd5)

/**
 使用系统库对字符串进行MD5加密
 
 @param string 要加密的字符串
 @return 加密后的字符串
 */
+ (NSString *)vp_hybrid_md5:(NSString *)string;

@end
