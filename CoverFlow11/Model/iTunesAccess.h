//
//  iTunesAccess.h
//  CoverFlow11
//
//  Created by Snow on 12-12-11.
//  Copyright (c) 2012年 Snow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iTunes.h"
@class iTunesAlbum;

enum iTunesStatusEnum
{
    Stopped,
    Playing,
    Paused,
    Unknow,
};
typedef enum iTunesStatusEnum iTunesStatusEnum;

@interface iTunesAccess : NSObject
{
    iTunesApplication *_iTunes;
    iTunesSource *_library;
    iTunesPlaylist *_playList;
    iTunesPlaylist *_cfPlayList;
}

+ (iTunesAccess *)sharediTunesAccess;

- (BOOL)isiTunesRunning;
- (void)runiTunes;
- (iTunesStatusEnum)getiTunesState;

- (NSInteger)getSoundVolumn;
- (void)setSoundVolumn:(NSInteger)value;

- (iTunesTrack *)getCurrentTrack;
- (NSArray *)getCurrentAlbums;
- (NSData *)loadArtworkData:(NSString *)album;

- (void)playAlbum:(iTunesAlbum *)album from:(NSInteger)index;

- (void)playPause;
- (void)playNextTrack;
- (void)playPreviousTrack;

@end
