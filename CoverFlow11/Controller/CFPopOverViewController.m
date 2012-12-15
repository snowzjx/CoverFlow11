//
//  CFPopOverViewController.m
//  CoverFlow11
//
//  Created by Snow on 12-12-11.
//  Copyright (c) 2012年 Snow. All rights reserved.
//

#import "CFPopOverViewController.h"
#import "CFView.h"
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
    NSLog(@"CFPopOverViewController - Current PlayList: %@",[playList name]);
    
    NSArray *albums = [theiTunesAccess getAlbumsInPlayList:playList];
    NSLog(@"CFPopOverViewController - Current Albums Are: ");
    for (iTunesAlbum *album in albums)
    {
        NSLog(@"\t%@",[album albumName]);
    }
    iTunesTrack * currentTrack = [theiTunesAccess getCurrentTrack];
    NSLog(@"CFPopOverViewController - Current Track is: %@",[currentTrack name]);
    [self setUpCFViewWithAlbums:albums andCurrentTrack:currentTrack];
    [cfView setUpLayers];
}

- (void)setUpCFViewWithAlbums:(NSArray *)albums andCurrentTrack:(iTunesTrack *)track
{
    NSLog(@"CFPopOverViewController - Setting date to the CFView ...");
    
    
    
    NSLog(@"CFPopOverViewController - Data Set Finished.");
}


@end
