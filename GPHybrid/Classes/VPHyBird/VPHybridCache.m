//
//  VPHybridCache.m
//  Pods
//
//  Created by gangpeng shu on 2017/6/2.
//
//

#import "VPHybridCache.h"


@interface VPHybridCache ()

@end


@implementation VPHybridCache

static inline NSString *cacheDir() {
    return [NSString stringWithFormat:@"%@%@%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                                                     firstObject],
                                      @"/VPCache", @"/WebFile/"];
}

+ (long long)getCacheSize {
    NSString *documentPath = cacheDir();
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:documentPath]) return 0;

    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:documentPath] objectEnumerator];
    NSString *fileName;
    long long folderSize = 0;

    while ((fileName = [childFilesEnumerator nextObject]) != nil) {
        NSString *fileAbsolutePath = [documentPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }

    return folderSize;
}

+ (long long)fileSizeAtPath:(NSString *)filePath {
    NSFileManager *manager = [NSFileManager defaultManager];

    if ([manager fileExistsAtPath:filePath]) {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }

    return 0;
}

+ (void)cleanCache {
    if ([[NSFileManager defaultManager] fileExistsAtPath:cacheDir()]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:cacheDir() error:&error];
        if (error) {

        } else {
        }
    }
}

@end
