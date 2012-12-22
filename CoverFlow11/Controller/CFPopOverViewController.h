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

@interface CFPopOverViewController : NSViewController<NSPopoverDelegate>
{
    // iTunesAccess
    iTunesAccess *_iTunesAccess;
    
    // Info related to iTunes
    NSArray *_albums;
    iTunesStatusEnum _iTunesStatus;
    NSInteger _soundVolumn;
    
    // Cover Flow View
    IBOutlet CFView *_cfView;
}

- (IBAction)playBtnClick:(id)sender;
- (IBAction)nextBtnClick:(id)sender;
- (IBAction)prevBtnClick:(id)sender;

@end
