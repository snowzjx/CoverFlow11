//
//  CFPopOverViewController.h
//  CoverFlow11
//
//  Created by Snow on 12-12-11.
//  Copyright (c) 2012年 Snow. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "iTunesAccess.h"
@class CFView;
@class CFItemPopOverViewController;

@interface CFPopOverViewController : NSViewController <NSPopoverDelegate>
{
    // iTunesAccess
    iTunesAccess *_iTunesAccess;
    
    // Info related to iTunes
    NSArray *_albums;
    iTunesStatusEnum _iTunesStatus;
    NSString *_currentAlbumName;
    NSInteger _soundVolumn;
    
    // Cover Flow View
    IBOutlet CFView *_cfView;
    
    // Cover Flow Item Song List View & Controller;
    NSPopover *_cfItemPopOver;
    CFItemPopOverViewController *_cfItemPopOverViewController;
}

@property(strong) IBOutlet NSButton *btnPlay;
@property(strong) IBOutlet NSButton *btnNext;
@property(strong) IBOutlet NSButton *btnPrev;
@property(strong) IBOutlet NSSlider *soundVolumnSlider;

- (IBAction)playBtnClick:(id)sender;
- (IBAction)nextBtnClick:(id)sender;
- (IBAction)prevBtnClick:(id)sender;
- (IBAction)soundVolumnSliderChange:(id)sender;

@end
