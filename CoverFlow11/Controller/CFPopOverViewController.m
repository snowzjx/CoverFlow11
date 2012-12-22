//
//  CFPopOverViewController.m
//  CoverFlow11
//
//  Created by Snow on 12-12-11.
//  Copyright (c) 2012年 Snow. All rights reserved.
//

#import "CFPopOverViewController.h"
#import "CFView.h"
#import "CFViewConstant.h"
#import "iTunesAccess.h"
#import "iTunesAlbum.h"

@interface CFPopOverViewController ()

- (void)_loadiTunesInfo;
- (void)_loadAlbumInfo;
- (void)_setUpCFView;
- (void)_updateCFView;

- (void)_registerForNotifications;
- (void)_unregisterForNotifications;
- (void)_handleSelectedCoverDoubleClick:(NSNotification *)notification;
- (void)_handleSelectedCoverClick:(NSNotification *)notification;

@end

@implementation CFPopOverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSLog(@"CFPopOverViewController - Initializing CFPopOverViewController ...");
        _iTunesAccess = [iTunesAccess sharediTunesAccess];
    }
    return self;
}

- (void)_loadiTunesInfo
{
    NSLog(@"CFPopOverViewController - Loading iTunes Info ...");
    _soundVolumn = [_iTunesAccess getSoundVolumn];
    _iTunesStatus = [_iTunesAccess getiTunesState];
}

- (void)_loadAlbumInfo
{
    if(_albums == nil)
    {
        NSLog(@"CFPopOverViewController - Loading Album Info ...");
        _albums = [_iTunesAccess getCurrentAlbums];
    }
}

- (void)_setUpCFView
{
    NSLog(@"CFPopOverViewController - Setting Up Cover Flow View ...");
    NSArray *content = [_albums valueForKey:@"artWork"];
    [_cfView setContent:content];
}

- (void)_updateCFView
{
    NSLog(@"CFPopOverViewController - Updating Cover Flow View ...");
    NSString *currentTrackName = [[_iTunesAccess getCurrentTrack] name];
    NSInteger selectedIndex = 0;
    for(int i = 0; i < [_albums count]; i++)
    {
        iTunesAlbum *album = [_albums objectAtIndex:i];
        if([[album trackNames] containsObject:currentTrackName])
        {
            selectedIndex = i;
            break;
        }
    }
    [_cfView setSelectedIndex:selectedIndex];
}

- (void)_registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_handleSelectedCoverDoubleClick:)
                                                 name:selectedCoverDoubleClickedNotification
                                               object:_cfView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_handleSelectedCoverClick:)
                                                 name:selectedCoverClickedNotification
                                               object:_cfView];
}

- (void)_unregisterForNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:selectedCoverDoubleClickedNotification object:_cfView];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:selectedCoverClickedNotification object:_cfView];
}

- (void)_handleSelectedCoverDoubleClick:(NSNotification *)notification
{
    NSInteger  selectedIndex = [[[notification userInfo] valueForKey:@"SelectedIndex"] intValue];
    [_iTunesAccess playAlbum:[_albums objectAtIndex:selectedIndex] from:0];
}

- (void)_handleSelectedCoverClick:(NSNotification *)notification
{
    NSInteger  selectedIndex = [[[notification userInfo] valueForKey:@"SelectedIndex"] intValue];
    NSLog(@"Unimplemented Function! Selected Index at: %ld",selectedIndex);
}

- (void)popoverWillShow:(NSNotification *)notification
{
    NSLog(@"CFPopOverViewController - Did Pop Over ...");
    [self _loadiTunesInfo];
    [self _loadAlbumInfo];
    [self _setUpCFView];
    [self _updateCFView];
    [self _registerForNotifications];
}

- (void)popoverDidClose:(NSNotification *)notification
{
    NSLog(@"CFPopOverViewController - Pop Over Did Close");
    [self _unregisterForNotifications];
}

- (void)playBtnClick:(id)sender
{
    [_iTunesAccess playPause];
}

- (void)nextBtnClick:(id)sender
{
    [_iTunesAccess playNextTrack];
    [self _updateCFView];
}

- (void)prevBtnClick:(id)sender
{
    [_iTunesAccess playPreviousTrack];
    [self _updateCFView];
}
@end
