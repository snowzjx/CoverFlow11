//
//  iTunesAccess.m
//  CoverFlow11
//
//  Created by Snow on 12-12-11.
//  Copyright (c) 2012年 Snow. All rights reserved.
//

#import "iTunesAccess.h"

@implementation iTunesAccess

+ (iTunesAccess *)sharediTunesAccess
{
    static iTunesAccess* sharedInstance = nil;
    
    if(sharedInstance == nil)
    {
        sharedInstance = [[iTunesAccess alloc] init];
    }
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
    }
    return self;
}


- (BOOL)isiTunesRunning
{
    return [iTunes isRunning];
}

- (void)runiTunes
{
    [iTunes run];
}



@end
