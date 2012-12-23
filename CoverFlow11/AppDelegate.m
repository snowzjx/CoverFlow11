
//
//  AppDelegate.m
//  CoverFlow11
//
//  Created by Snow on 12-12-11.
//  Copyright (c) 2012年 Snow. All rights reserved.
//

#import "AppDelegate.h"
#import "CFPopOverViewController.h"

@interface AppDelegate ()

- (void)_menuInit;
- (void)_cfPopOverInit;
- (void)_showCFPopOver:(id)sender;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    NSLog(@"AppDelegate - Application Initializing ...");
    [self _menuInit];
    [self _cfPopOverInit];
}

- (void)_menuInit
{
    NSLog(@"AppDelegate - Initializing Menu ...");
    if(statusItem)
    {
        [[NSStatusBar systemStatusBar] removeStatusItem:statusItem];
        statusItem = nil;
    }
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:30.0f];
    [statusItem setImage:[NSImage imageNamed:@"StatusItemIcon"]];
    [statusItem setAlternateImage:[NSImage imageNamed:@"StatusItemIconHighlight"]];
    [statusItem setHighlightMode:YES];
    [statusItem setToolTip:@"CoverFlow11"];
    [statusItem setAction:@selector(_showCFPopOver:)];
    NSLog(@"AppDelegate - Finished Initializing Menu.");
}

- (void)_cfPopOverInit
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
    [cfPopOver setDelegate:cfPopOverViewController];
    NSLog(@"AppDelegate - Finished Initializing CoverFlow11 PopOver.");
}

- (void)_showCFPopOver:(id)sender
{
    NSLog(@"AppDelegate - Going to Show CoverFlow11 PopOver ...");
    [cfPopOver showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMinYEdge];
}


@end
