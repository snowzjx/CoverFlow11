//
//  iTunesAccess.m
//  CoverFlow11
//
//  Created by Snow on 12-12-11.
//  Copyright (c) 2012年 Snow. All rights reserved.
//

#import "iTunesAccess.h"
#import "iTunesAlbum.h"

@interface iTunesAccess ()

- (void)_loadLibrary;
- (void)_loadPlayList;
- (void)_loadCFPlayList;

@end
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
        _iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
        [self _loadLibrary];
        [self _loadPlayList];
        [self _loadCFPlayList];
    }
    return self;
}

- (BOOL)isiTunesRunning
{
    return [_iTunes isRunning];
}

- (void)runiTunes
{
    [_iTunes run];
}

- (iTunesStatusEnum)getiTunesState
{
    iTunesEPlS state= [_iTunes playerState];
    switch (state)
    {
        case iTunesEPlSStopped:
            return Stopped;
            break;
        case iTunesEPlSPaused:
            return Paused;
            break;
        case iTunesEPlSPlaying:
            return Playing;
            break;
        default:
            return Unknow;
            break;
    }
}

- (NSInteger)getSoundVolumn
{
    return [_iTunes soundVolume];
}

- (void)setSoundVolumn:(NSInteger)value
{
    [_iTunes setSoundVolume:value];
}

- (iTunesTrack *)getCurrentTrack
{
    return [_iTunes currentTrack];
}

- (NSArray *)getCurrentAlbums
{
    NSMutableArray *albums = [[NSMutableArray alloc] init];
    
    NSArray *albumNames = [[_playList tracks] arrayByApplyingSelector:@selector(album)];
    NSArray *trackNames = [[_playList tracks] arrayByApplyingSelector:@selector(name)];
    
    NSMutableDictionary *albumHelpDict = [[NSMutableDictionary alloc] init];
    for(int i = 0; i < [albumNames count]; i++)
    {
        NSString *albumName = [albumNames objectAtIndex:i];
        NSString *trackName = [trackNames objectAtIndex:i];
        
        NSMutableArray *value = [albumHelpDict objectForKey:albumName];
        if(value == nil)
        {
            value = [[NSMutableArray alloc] init];
            [value addObject:trackName];
            [albumHelpDict setObject:value forKey:albumName];
        }
        else
        {
            [value addObject:trackName];
        }
    }
    
    for(NSString *albumName in [albumHelpDict allKeys])
    {
        NSPredicate *prdtAlbum = [NSPredicate predicateWithFormat:@"album = %@",albumName];
        NSArray *tracks = [[_playList tracks] filteredArrayUsingPredicate:prdtAlbum];
        iTunesArtwork *artWork = [[[tracks objectAtIndex:0] artworks] lastObject];
        NSImage *artWorkImage = [[NSImage alloc] initWithData:[artWork rawData]];
        
        iTunesAlbum *album = [[iTunesAlbum alloc] init];
        [album setAlbum:albumName];
        [album setArtWork:artWorkImage];
        [album setTrackNames:[albumHelpDict objectForKey:albumName]];
        [album setTracks:tracks];
        [albums addObject:album];
    }
    return albums;
}

- (void)playAlbum:(iTunesAlbum *)album from:(NSInteger)index
{
    [[_cfPlayList tracks] removeAllObjects];
    NSArray *tracks = [album tracks];
    NSMutableArray *orderedTracks = [[NSMutableArray alloc] init];
    
    for(NSInteger i = index; i < [tracks count]; i++)
    {
        [orderedTracks addObject:[tracks objectAtIndex:i]];
    }
    for(NSInteger i = 0; i < index ; i++)
    {
        [orderedTracks addObject:[tracks objectAtIndex:i]];
    }
    
    [orderedTracks makeObjectsPerformSelector:@selector(duplicateTo:) withObject:_cfPlayList];
    [_cfPlayList playOnce:YES];
}

- (void)playPause
{
    [_iTunes playpause];
}

- (void)playNextTrack
{
    [_iTunes nextTrack];
}

- (void)playPreviousTrack
{
    [_iTunes previousTrack];
}

- (void)_loadLibrary
{
    if(_library == nil)
    {
        NSPredicate *prdtLib = [NSPredicate predicateWithFormat:@"kind = %@",[NSAppleEventDescriptor descriptorWithTypeCode:iTunesESrcLibrary]];
        SBElementArray *sources = [_iTunes sources];
        _library = [[sources filteredArrayUsingPredicate:prdtLib] objectAtIndex:0];
    }
}

- (void)_loadPlayList
{
    if(_playList == nil)
    {
        NSPredicate *prdtPlayList = [NSPredicate predicateWithFormat:@"specialKind = %@", [NSAppleEventDescriptor descriptorWithTypeCode:iTunesESpKMusic]];
        _playList = [[[_library playlists] filteredArrayUsingPredicate:prdtPlayList] objectAtIndex:0];
    }
}

- (void)_loadCFPlayList
{
    NSString *playListName = @"CoverFlow";
    if(_cfPlayList == nil)
    {
        NSPredicate *prdtCFPlayList = [NSPredicate predicateWithFormat:@"name = %@", playListName];
        _cfPlayList = [[[_library playlists] filteredArrayUsingPredicate:prdtCFPlayList] objectAtIndex:0];
        if(![_cfPlayList exists])
        {
            _cfPlayList = [[[_iTunes classForScriptingClass:@"playlist"] alloc] init];
            [[_library userPlaylists] insertObject:_cfPlayList atIndex:0];
            [_cfPlayList setName:playListName];
        }
    }
}

@end
