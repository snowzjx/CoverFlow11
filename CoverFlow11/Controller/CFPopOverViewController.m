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
    NSLog(@"CFPopOverViewController - Current PlayList: %@",[playList name]);
    
    NSArray *albums = [theiTunesAccess getAlbumsInPlayList:playList];
    NSLog(@"CFPopOverViewController - Current Albums Are: ");
    for (iTunesAlbum *album in albums)
    {
        NSLog(@"\t%@",[album albumName]);
    }
    iTunesTrack * currentTrack = [theiTunesAccess getCurrentTrack];
    NSLog(@"CFPopOverViewController - Current Track is: %@",currentTrack != nil ? [currentTrack name] : @"NO TRACK");
    [self setUpCFViewWithAlbums:albums andCurrentTrack:currentTrack];
    [cfView setUpLayers];
    [cfView layoutCoverFlowsAnimated:YES];
}

- (void)setUpCFViewWithAlbums:(NSArray *)albums andCurrentTrack:(iTunesTrack *)track
{
    NSLog(@"CFPopOverViewController - Setting date to the CFView ...");
    NSMutableArray *cfItemViews = [[NSMutableArray alloc] init];
    NSNumber *index = nil;
    for (int i = 0; i < [albums count]; i++)
    {
        iTunesAlbum *album = [albums objectAtIndex:i];
        if(track != nil && [[album albumName]isEqualToString:[track album]])
        {
            index = [NSNumber numberWithInt:i];
        }
        CFItemView * itemView = [[CFItemView alloc] initWithFrame:NSMakeRect(0.0f, 0.0f, COVER_FLOW_ITEM_WIDTH, COVER_FLOW_ITEM_HEIGHT)];
        [itemView setUpLayers];
        [itemView setImage:[album albumArtWork]];
        [cfItemViews addObject:itemView];
    }
    if(index == nil)
    {
        index = [NSNumber numberWithInt:0];
    }
    NSLog(@"CFPopOverViewController - Seleted Index is: %d",[index intValue]);
    [cfView setSelectedIndex:index];
    [cfView setCfItemViews:cfItemViews];
    NSLog(@"CFPopOverViewController - Data Set Finished.");
}

// Test interface
- (IBAction)goBtnClick:(id)sender
{
    int _index = [[cfView selectedIndex] intValue];
    if(_index < [[cfView cfItemViews] count] -1)
    {
        _index ++;
        [cfView setSelectedIndex:[NSNumber numberWithInt:_index]];
        [cfView layoutCoverFlowsAnimated:YES];
    }
}

-(IBAction)backBtnClick:(id)sender
{
    int _index = [[cfView selectedIndex] intValue];
    if(_index > 0)
    {
        _index --;
        [cfView setSelectedIndex:[NSNumber numberWithInt:_index]];
        [cfView layoutCoverFlowsAnimated:YES];
    }
}

@end
