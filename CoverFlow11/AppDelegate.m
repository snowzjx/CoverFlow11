
//
//  AppDelegate.m
//  CoverFlow11
//
//  Created by Snow on 12-12-11.
//  Copyright (c) 2012年 Snow. All rights reserved.
//

#import "AppDelegate.h"
#import "CFPopOverViewController.h"
#import "CFStatusItemView.h"

@interface AppDelegate ()

- (void)_menuInit;
- (void)_statusItemInit;
- (void)_cfPopOverInit;
- (void)_showCFPopOver:(id)sender;
- (void)_showAboutPanel:(id)sender;
- (void)_showPreferencePanel:(id)sender;
- (void)_quit:(id)sender;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    NSLog(@"AppDelegate - Application Initializing ...");
    [self _menuInit];
    [self _statusItemInit];
    [self _cfPopOverInit];
}

- (void)_menuInit
{
    NSLog(@"AppDelegate - Initializing Menu ...");
    _menu = [[NSMenu alloc] initWithTitle:@"CoverFlow"];
    [_menu addItemWithTitle:NSLocalizedString(@"About CoverFlow11", nil)
                     action:@selector(_showAboutPanel:)
              keyEquivalent:@""];
    [_menu addItem:[NSMenuItem separatorItem]];
    [_menu addItemWithTitle:NSLocalizedString(@"Preferences...", nil)
                     action:@selector(_showPreferencePanel:)
              keyEquivalent:@";"];
    [_menu addItem:[NSMenuItem separatorItem]];
    [_menu addItemWithTitle:NSLocalizedString(@"Quit CoverFlow11", nil)
                     action:@selector(_quit:)
              keyEquivalent:@"q"];
}

- (void)_statusItemInit
{
    NSLog(@"AppDelegate - Initializing Status Item ...");
    if(_statusItem)
    {
        [[NSStatusBar systemStatusBar] removeStatusItem:_statusItem];
        _statusItem = nil;
    }
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    CFStatusItemView *statusItemView = [[CFStatusItemView alloc] initWithStatusBarItem:_statusItem];
    [_statusItem setView:statusItemView];
    [statusItemView setImage:[NSImage imageNamed:@"statusitemicon"]];
    [statusItemView setAlternateImage:[NSImage imageNamed:@"statusitemiconhighlight"]];
    [statusItemView setTarget:self];
    [statusItemView setAction:@selector(_showCFPopOver:)];
    [statusItemView setRightMenu:_menu];
    [statusItemView setToolTip:@"CoverFlow11"];
}

- (void)_cfPopOverInit
{
    NSLog(@"AppDelegate - Initializing CoverFlow11 PopOver ...");
    if(cfPopOverViewController == nil)
    {
        cfPopOverViewController = [[CFPopOverViewController alloc] initWithNibName:@"CFPopOverView" bundle:nil];
    }
    if(_cfPopOver == nil)
    {
        _cfPopOver = [[NSPopover alloc] init];
    }
    [_cfPopOver setContentViewController:cfPopOverViewController];
    [_cfPopOver setBehavior:NSPopoverBehaviorTransient];
    [_cfPopOver setDelegate:cfPopOverViewController];
}

- (void)_showCFPopOver:(id)sender
{
    NSLog(@"AppDelegate - Going to Show CoverFlow11 PopOver ...");
    [NSApp activateIgnoringOtherApps:YES];
    [_cfPopOver showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMinYEdge];
}

- (void)_showAboutPanel:(id)sender
{
    NSLog(@"AppDelegate - Showing About Panel ...");
    [[NSApplication sharedApplication] orderFrontStandardAboutPanel:self];
}

- (void)_showPreferencePanel:(id)sender
{
    NSLog(@"AppDelegate - Showing Preference Panel ...");
}

- (void)_quit:(id)sender
{
    NSLog(@"AppDelegate - Quiting ...");
    [[NSApplication sharedApplication] terminate:self];
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    NSLog(@"AppDelegate - Application Will Terminate ...");
    [[NSStatusBar systemStatusBar] removeStatusItem:_statusItem];
}
@end
