//
//  CFItemPopOverViewController.m
//  CoverFlow11
//
//  Created by Snow on 12-12-29.
//  Copyright (c) 2012年 Snow. All rights reserved.
//

#import "CFItemPopOverViewController.h"
#import "iTunesAccess.h"
#import "iTunesAlbum.h"
#import "Color11.h"
#import "CFSongListView.h"

@interface CFItemPopOverViewController ()

- (void)_color11Album;
- (void)_setUpCFSongListView;

@end

@implementation CFItemPopOverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        _iTunesAccess = [iTunesAccess sharediTunesAccess];
    }
    return self;
}

- (void)setAlbum:(iTunesAlbum *)album
{
    if(_album != album)
    {
        _album = album;
        [self _color11Album];
    }
}

- (void)_color11Album;
{
    NSData *data = [_iTunesAccess loadArtworkData:[_album album]];
    NSImage *artwork = [[NSImage alloc] initWithData:data];
    NSDictionary *colorsDictionary = [Color11 dictionaryWithColorsPickedFromImage:artwork];
    _backgroundColor = [colorsDictionary objectForKey:@"BackgroundColor"];
    _primaryTextColor = [colorsDictionary objectForKey:@"PrimaryTextColor"];
    _secondaryTextColor = [colorsDictionary objectForKey:@"SecondaryTextColor"];
}

- (void)_setUpCFSongListView
{
    [_cfSongListView setAlbum:[_album album]];
    [_cfSongListView setTracks:[_album tracks]];
    [_cfSongListView setBackgroundColor:_backgroundColor];
    [_cfSongListView setPrimaryTextColor:_primaryTextColor];
    [_cfSongListView setSecondaryTextColor:_secondaryTextColor];
}

- (void)popoverWillShow:(NSNotification *)notification
{
    [self _setUpCFSongListView];
    [_cfSongListView showCFSongList];
}

- (void)popoverDidClose:(NSNotification *)notification
{
    
}
@end
