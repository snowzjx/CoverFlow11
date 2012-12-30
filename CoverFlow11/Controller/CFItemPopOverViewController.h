//
//  CFItemPopOverViewController.h
//  CoverFlow11
//
//  Created by Snow on 12-12-29.
//  Copyright (c) 2012年 Snow. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class iTunesAccess;
@class iTunesAlbum;
@class CFSongListView;

@interface CFItemPopOverViewController : NSViewController <NSPopoverDelegate>
{
    // iTunesAccess
    iTunesAccess *_iTunesAccess;
    
    // CFSongListView
    IBOutlet CFSongListView *_cfSongListView;
    
    // NSColors
    NSColor *_backgroundColor;
    NSColor *_primaryTextColor;
    NSColor *_secondaryTextColor;
}

@property(nonatomic,assign) iTunesAlbum* album;

@end
