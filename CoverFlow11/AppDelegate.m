
//
//  AppDelegate.m
//  CoverFlow11
//
//  Created by Snow on 12-12-11.
//  Copyright (c) 2012年 Snow. All rights reserved.
//

#import "AppDelegate.h"
#import "CFPopOverViewController.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    NSLog(@"AppDelegate - Application Initializing ...");
    [self menuInit];
    [self cfPopOverInit];
}

- (void)menuInit
{
    NSLog(@"AppDelegate - Initializing Menu ...");
    if(statusItem)
    {
        [[NSStatusBar systemStatusBar] removeStatusItem:statusItem];
        statusItem = nil;
    }
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:30.0f];
    [statusItem setTitle:@"CF"];
    // [_statusItem setImage:nil];
    // [_statusItem setAlternateImage:nil];
    [statusItem setHighlightMode:YES];
    [statusItem setToolTip:@"CoverFlow11"];
    [statusItem setAction:@selector(showCFPopOver:)];
    NSLog(@"AppDelegate - Finished Initializing Menu.");
}

- (void)cfPopOverInit
{
    NSLog(@"AppDelegate - Initializing CoverFlow11 PopOver ...");
    if(cfPopOverViewController == nil)
    {
        cfPopOverViewController = [[CFPopOverViewController alloc] initWithNibName:@"CFPopOverView" bundle:nil];
    }
    if(cfPopOver == nil)
    {
        cfPopOver = [[NSPopover alloc] init];
    }
    [cfPopOver setContentViewController:cfPopOverViewController];
    [cfPopOver setBehavior:NSPopoverBehaviorTransient];
    NSLog(@"AppDelegate - Finished Initializing CoverFlow11 PopOver.");
}

- (void)showCFPopOver:(id)sender
{
    NSLog(@"AppDelegate - Going to Show CoverFlow11 PopOver ...");
    [cfPopOver showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMinYEdge];
    [cfPopOverViewController didPopOver];
}

@end
