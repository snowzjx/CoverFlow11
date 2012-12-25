//
//  CFImageDataSourceiTunes.h
//  CoverFlow11
//
//  Created by Snow on 12-12-25.
//  Copyright (c) 2012年 Snow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CFImageDataSourceDelegate.h"
@class iTunesAccess;

@interface CFImageDataSourceiTunes : NSObject<CFImageDataSourceDelegate>
{
    iTunesAccess *_iTunesAccess;
}

+ (CFImageDataSourceiTunes *) sharedInstance;
- (NSData *)loadImageDataFromKey:(NSString *)imageKey;

@end
