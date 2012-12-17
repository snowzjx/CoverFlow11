//
//  CFPopOverViewController.m
//  CoverFlow11
//
//  Created by Snow on 12-12-11.
//  Copyright (c) 2012年 Snow. All rights reserved.
//

#import "CFPopOverViewController.h"
#import "CFView.h"
#import "CFItemView.h"
#import "CFViewConstant.h"
#import "iTunesAccess.h"
#import "iTunesAlbum.h"

@interface CFPopOverViewController ()

@end

@implementation CFPopOverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSLog(@"CFPopOverViewController - Initializing CFPopOverViewController ...");
        theiTunesAccess = [iTunesAccess sharediTunesAccess];
    }
    return self;
}

- (void)didPopOver
{
    NSLog(@"CFPopOverViewController - Will Pop Over ...");
    if(![theiTunesAccess isiTunesRunning])
    {
        NSLog(@"CFPopOverViewController - Run iTunes ...");
        [theiTunesAccess runiTunes];
    }
    
    iTunesPlaylist *playList = [theiTunesAccess getCurrentPlayList];
    if (![currentPlayList isEqualTo:playList])
    {
        NSLog(@"CFPopOverViewController - Reload Data & Re Draw Layers ...");
        currentPlayList = playList;
        [cfView removeAllCoverFlows];
        [self setUpAlbumInfo];
        [self addCFItemsToCFView];
    }
    
    currentTrack = [theiTunesAccess getCurrentTrack];
    
    selectedIndex = [self findTrack:currentTrack inAlbums:currentAlbums];
    
    if(selectedIndex == 0)
    {
        selectedIndex = [currentAlbums count] / 2;
    }
    [cfView layoutCoverFlowSelectedAt:selectedIndex animated:YES];
}

- (void)setUpAlbumInfo
{
    NSLog(@"CFPopOverViewController - Setting Up Album Info ...");
    NSMutableDictionary *albumDict = [[NSMutableDictionary alloc] init];
    for(iTunesTrack *track in [[currentPlayList tracks] get])
    {
        iTunesAlbum *album = [albumDict valueForKey:[track album]];
        if(album == nil)
        {
            album = [[iTunesAlbum alloc] init];
            [album setAlbumName:[track album]];
            NSImage *albumImage =[[NSImage alloc] initWithData:[[[track artworks] lastObject] rawData]];
            [album setAlbumArtWork:albumImage];
            album.albumTracks = [[NSMutableArray alloc] init];
            [album.albumTracks addObject:track];
            [albumDict setValue:album forKey:[track album]];
        }
        else
        {
            [album.albumTracks addObject:track];
        }
    }
    currentAlbums = [albumDict allValues];
}

- (void)addCFItemsToCFView
{
    NSLog(@"CFPopOverViewController - Adding Cover Flow Item Views to CF View ...");
    for(iTunesAlbum *album in currentAlbums)
    {
        [cfView addImage:[album albumArtWork]];
    }
}

- (NSInteger)findTrack:(iTunesTrack *)track inAlbums:(NSArray *)albums
{
    for(int i = 0; i < [albums count]; i++)
    {
        iTunesAlbum *album = [albums objectAtIndex:i];
        if([[album albumTracks] containsObject:track])
        {
            return  i;
        }
    }
    return 0;
}


// Test interface
- (IBAction)goBtnClick:(id)sender
{
    if(selectedIndex < [currentAlbums count] - 1)
    {
        selectedIndex += 5;
        [cfView layoutCoverFlowSelectedAt:selectedIndex animated:YES];
    }
}

-(IBAction)backBtnClick:(id)sender
{
    if(selectedIndex > 0)
    {
        selectedIndex -= 1;
        [cfView layoutCoverFlowSelectedAt:selectedIndex animated:YES];
    }
}

@end
