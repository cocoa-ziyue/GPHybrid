//
//  NSString+md5.m
//  Pods
//
//  Created by Jia Yuanfa on 2017/3/24.
//
//

#import "NSString+Hybridmd5.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NSString (Hybridmd5)

+ (NSString *)GP_hybrid_md5:(NSString *)string {
    if (string == nil || [string length] == 0) {
        return nil;
    }

    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5([string UTF8String], (int)[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];

    for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ms appendFormat:@"%02x", (int)(digest[i])];
    }

    return [ms copy];
}

@end
