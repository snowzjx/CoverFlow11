//
//  CFPopOverViewController.h
//  CoverFlow11
//
//  Created by Snow on 12-12-11.
//  Copyright (c) 2012年 Snow. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class iTunesAccess;
@class iTunesPlaylist;
@class iTunesTrack;
@class CFView;

@interface CFPopOverViewController : NSViewController
{
    iTunesAccess *theiTunesAccess;
    iTunesPlaylist *currentPlayList;
    NSArray *currentAlbums;
    iTunesTrack *currentTrack;
        
    IBOutlet CFView *cfView;
}

- (void)didPopOver;
- (IBAction)goBtnClick:(id)sender;
- (IBAction)backBtnClick:(id)sender;

@end
