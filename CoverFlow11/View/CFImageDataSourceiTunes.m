//
//  CFImageDataSourceiTunes.m
//  CoverFlow11
//
//  Created by Snow on 12-12-25.
//  Copyright (c) 2012年 Snow. All rights reserved.
//

#import "CFImageDataSourceiTunes.h"
#import "iTunesAccess.h"

@implementation CFImageDataSourceiTunes

+ (CFImageDataSourceiTunes *)sharedInstance
{
    static CFImageDataSourceiTunes *sharedInstance = nil;
    if(sharedInstance == nil)
    {
        sharedInstance = [[CFImageDataSourceiTunes alloc] init];
    }
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        _iTunesAccess = [iTunesAccess sharediTunesAccess];
    }
    return self;
}

- (NSData *)loadImageDataFromKey:(NSString *)imageKey
{
    return [_iTunesAccess loadArtworkData:imageKey];
}

@end
