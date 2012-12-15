//
//  iTunesAccess.h
//  CoverFlow11
//
//  Created by Snow on 12-12-11.
//  Copyright (c) 2012年 Snow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iTunes.h"

@interface iTunesAccess : NSObject
{
    iTunesApplication *iTunes;
    iTunesSource *library;
}

+ (iTunesAccess *)sharediTunesAccess;

- (BOOL)isiTunesRunning;
- (void)runiTunes;
- (iTunesTrack *)getCurrentTrack;
- (iTunesPlaylist *)getCurrentPlayList;
- (NSArray *)getAlbumsInPlayList:(iTunesPlaylist *) playList;

@end
