//
//  iTunesAccess.m
//  CoverFlow11
//
//  Created by Snow on 12-12-11.
//  Copyright (c) 2012年 Snow. All rights reserved.
//

#import "iTunesAccess.h"
#import "iTunesAlbum.h"

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

- (iTunesTrack *)getCurrentTrack
{
    return [[iTunes currentTrack] get];
}

- (iTunesPlaylist *)getCurrentPlayList
{
    NSLog(@"iTunesAccess - Getting Current Play List ...");
    iTunesPlaylist *playList = [[iTunes currentPlaylist] get];
    if(!playList.exists)
    {
        NSLog(@"iTunesAccess - Locating the playlist ... ");
        if(library == nil)
        {
            NSPredicate *prdtLib = [NSPredicate predicateWithFormat:@"kind = %@",[NSAppleEventDescriptor descriptorWithTypeCode:iTunesESrcLibrary]];
            SBElementArray *sources = [iTunes sources];
            library = [[sources filteredArrayUsingPredicate:prdtLib] objectAtIndex:0];
        }
        
        if(library == nil)
        {
            NSLog(@"iTunesAccess - Can't Locate the Library!");
            return nil;
        }
        NSLog(@"iTunesAccess - Library Located.");
        NSLog(@"iTunesAccess - Locating the Default Playlist ...");
        NSPredicate *prdtPlayList = [NSPredicate predicateWithFormat:@"specialKind = %@", [NSAppleEventDescriptor descriptorWithTypeCode:iTunesESpKMusic]];
        playList = [[[library playlists] filteredArrayUsingPredicate:prdtPlayList] objectAtIndex:0];
        NSLog(@"iTunesAccess - Default Playlist Located.");
    }
    return playList;
}

@end
