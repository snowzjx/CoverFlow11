//
//  AppDelegate.h
//  CoverFlow11
//
//  Created by Snow on 12-12-11.
//  Copyright (c) 2012年 Snow. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class CFPopOverViewController;

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    // Controls
    NSStatusItem *_statusItem;
    NSMenu *_menu;
    NSPopover *_cfPopOver;
 
    // ViewControllers
    CFPopOverViewController *cfPopOverViewController;
}

@end
