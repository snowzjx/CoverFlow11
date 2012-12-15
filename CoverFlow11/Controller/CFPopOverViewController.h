//
//  CFPopOverViewController.h
//  CoverFlow11
//
//  Created by Snow on 12-12-11.
//  Copyright (c) 2012年 Snow. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class iTunesAccess;
@class CFView;

@interface CFPopOverViewController : NSViewController
{
    iTunesAccess *theiTunesAccess;
    IBOutlet CFView *cfView;
}

- (void)didPopOver;

@end
