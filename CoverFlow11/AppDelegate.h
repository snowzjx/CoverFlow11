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
    NSStatusItem *statusItem;
    NSPopover *cfPopOver;
 
    // ViewControllers
    CFPopOverViewController *cfPopOverViewController;
}

@end
