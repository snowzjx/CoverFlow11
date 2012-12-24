//
//  CFStatusItemView.h
//  CoverFlow11
//
//  Created by Snow on 12-12-24.
//  Copyright (c) 2012年 Snow. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CFStatusItemView : NSControl
{
    BOOL _isMouseDown;
    BOOL _isMenuVisible;
}

@property(nonatomic, assign) NSStatusItem *statusItem;
@property(nonatomic, strong) NSImage *image;
@property(nonatomic, strong) NSImage *alternateImage;

@property(nonatomic, strong) id target;
@property(nonatomic, assign) SEL action;
@property(nonatomic, assign) NSMenu *rightMenu;

- (id)initWithStatusBarItem:(NSStatusItem *)statusItem;

@end
