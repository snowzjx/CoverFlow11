//
//  CFSongListView.h
//  CoverFlow11
//
//  Created by Snow on 12-12-30.
//  Copyright (c) 2012年 Snow. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface CFSongListView : NSView
{
    // Layers
    CALayer *_rootLayer;
    CALayer *_contentLayer;
    CATextLayer *_titleLayer;
    CAScrollLayer *_scrollLayer;
    
    NSInteger _scrollIndex;
}

@property(nonatomic, assign) NSString *album;
@property(nonatomic, assign) NSArray *tracks;
@property(nonatomic, assign) NSColor *backgroundColor;
@property(nonatomic, assign) NSColor *primaryTextColor;
@property(nonatomic, assign) NSColor *secondaryTextColor;

- (void)showCFSongList;

@end
