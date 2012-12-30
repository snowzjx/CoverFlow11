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
#import "CFImageDataSourceiTunes.h"
#import "CFItemPopOverViewController.h"

#import "iTunesAccess.h"
#import "iTunesAlbum.h"

#import "Color11.h"

@interface CFPopOverViewController ()

- (void)_loadiTunesInfo;
- (void)_loadAlbumInfo;
- (void)_loadCurrentInfo;
- (void)_setUpCFView;
- (void)_updateCFView;
- (void)_updateControls;

- (void)_setUpCFItemPopOver:(iTunesAlbum *)album;
- (void)_showCFItemPopOver;
- (void)_hideCFItemPopOver;

- (void)_registerForNotifications;
- (void)_unregisterForNotifications;
- (void)_handleSelectedCoverDoubleClick:(NSNotification *)notification;
- (void)_handleSelectedCoverClick:(NSNotification *)notification;
- (void)_handleiTunesNotifications:(NSNotification *)notification;

@end

@implementation CFPopOverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        _iTunesAccess = [iTunesAccess sharediTunesAccess];
    }
    return self;
}

- (void)_loadiTunesInfo
{
    _soundVolumn = [_iTunesAccess getSoundVolumn];
    _iTunesStatus = [_iTunesAccess getiTunesState];
}

- (void)_loadAlbumInfo
{
    if(_albums == nil)
    {
        _albums = [_iTunesAccess getCurrentAlbums];
    }
}

- (void)_loadCurrentInfo
{
    _currentAlbumName = [[_iTunesAccess getCurrentTrack] album];
}

- (void)_setUpCFView
{
    CFImageDataSourceiTunes *dataSource = [CFImageDataSourceiTunes sharedInstance];
    [_cfView setImageDataSourceDelegate:dataSource];
    NSArray *content = [_albums valueForKey:@"album"];
    [_cfView setContent:content];
}

- (void)_updateCFView
{
    NSInteger selectedIndex = 0;
    for(int i = 0; i < [_albums count]; i++)
    {
        iTunesAlbum *album = [_albums objectAtIndex:i];
        if([[album album] isEqualToString:_currentAlbumName])
        {
            selectedIndex = i;
            break;
        }
    }
    [_cfView setSelectedIndex:selectedIndex];
}

- (void)_updateControls
{
    if(_iTunesStatus == Stopped)
    {
        [_btnNext setEnabled:NO];
        [_btnPrev setEnabled:NO];
    }
    if(_iTunesStatus == Playing)
    {
        [_btnNext setEnabled:YES];
        [_btnPrev setEnabled:YES];
        [_btnPlay setImage:[NSImage imageNamed:@"btnpause"]];
        [_btnPlay setAlternateImage:[NSImage imageNamed:@"btnpausehighlight"]];
    }
    [_soundVolumnSlider setIntegerValue:_soundVolumn];
}

- (void)_setUpCFItemPopOver:(iTunesAlbum *)album
{
    if(_cfItemPopOverViewController == nil)
    {
        _cfItemPopOverViewController = [[CFItemPopOverViewController alloc] initWithNibName:@"CFItemPopOverView" bundle:nil];
    }
    if(_cfItemPopOver == nil)
    {
        _cfItemPopOver = [[NSPopover alloc] init];
        [_cfItemPopOver setContentViewController:_cfItemPopOverViewController];
        [_cfItemPopOver setBehavior:NSPopoverBehaviorTransient];
        [_cfItemPopOver setAppearance:NSPopoverAppearanceHUD];
        [_cfItemPopOver setDelegate:_cfItemPopOverViewController];
    }
    [_cfItemPopOverViewController setAlbum:album];
}

- (void)_showCFItemPopOver
{
    [_cfItemPopOver showRelativeToRect:NSMakeRect(0.0f, 50.0f, 500.0f, 200.0f) ofView:_cfView preferredEdge:NSMinYEdge];
    [self addObserver:self forKeyPath:@"_cfView.selectedIndex" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)_hideCFItemPopOver
{
    [_cfItemPopOver close];
    [self removeObserver:self forKeyPath:@"_cfView.selectedIndex"];
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
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self
                                                        selector:@selector(_handleiTunesNotifications:)
                                                            name:@"com.apple.iTunes.playerInfo"
                                                          object:nil];
}

- (void)_unregisterForNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:selectedCoverDoubleClickedNotification object:_cfView];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:selectedCoverClickedNotification object:_cfView];
    [[NSDistributedNotificationCenter defaultCenter] removeObserver:self name:@"com.apple.iTunes.playerInfo" object:nil];
}

- (void)_handleSelectedCoverDoubleClick:(NSNotification *)notification
{
    NSInteger  selectedIndex = [[[notification userInfo] valueForKey:@"SelectedIndex"] intValue];
    [_iTunesAccess playAlbum:[_albums objectAtIndex:selectedIndex] from:0];
}

- (void)_handleSelectedCoverClick:(NSNotification *)notification
{
    NSInteger  selectedIndex = [[[notification userInfo] valueForKey:@"SelectedIndex"] intValue];
    [self _setUpCFItemPopOver:[_albums objectAtIndex:selectedIndex]];
    [self _showCFItemPopOver];
}

- (void)_handleiTunesNotifications:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    NSString *playerState = [userInfo valueForKey:@"Player State"];
    iTunesStatusEnum stateEnum = Unknow;
    if([playerState isEqualToString:@"Playing"])
    {
        stateEnum = Playing;
    }
    if([playerState isEqualToString:@"Paused"])
    {
        stateEnum = Paused;
    }
    if(_iTunesStatus != stateEnum)
    {
        if(stateEnum == Playing)
        {
            _iTunesStatus = Playing;
            [_btnPlay setImage:[NSImage imageNamed:@"btnpause"]];
            [_btnPlay setAlternateImage:[NSImage imageNamed:@"btnpausehighlight"]];
            [_btnNext setEnabled:YES];
            [_btnPrev setEnabled:YES];
        }
        if(stateEnum == Paused)
        {
            _iTunesStatus = Paused;
            [_btnPlay setImage:[NSImage imageNamed:@"btnplay"]];
            [_btnPlay setAlternateImage:[NSImage imageNamed:@"btnplayhighlight"]];
            [_btnNext setEnabled:YES];
            [_btnPrev setEnabled:YES];
        }
    }
    
    NSString *currentAlbumName = [userInfo valueForKey:@"Album"];
    if(currentAlbumName != nil)
    {
        _currentAlbumName = currentAlbumName;
        [self _updateCFView];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"_cfView.selectedIndex"])
    {
        [self _hideCFItemPopOver];
    }
}

- (void)popoverWillShow:(NSNotification *)notification
{
    [self _loadiTunesInfo];
    [self _loadAlbumInfo];
    [self _loadCurrentInfo];
    [self _setUpCFView];
    [self _updateCFView];
    [self _updateControls];
    [self _registerForNotifications];
}

- (void)popoverDidClose:(NSNotification *)notification
{
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

- (void)soundVolumnSliderChange:(id)sender
{
    _soundVolumn = [_soundVolumnSlider integerValue];
    [_iTunesAccess setSoundVolumn:_soundVolumn];
}
@end
