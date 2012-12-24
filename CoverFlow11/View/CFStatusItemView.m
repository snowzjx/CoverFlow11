//
//  CFStatusItemView.m
//  CoverFlow11
//
//  Created by Snow on 12-12-24.
//  Copyright (c) 2012年 Snow. All rights reserved.
//

#import "CFStatusItemView.h"

@interface CFStatusItemView ()

- (void)_drawImage:(NSImage *)aImage centeredInRect:(NSRect)aRect;
- (void)_popUpRightMenu;
- (void)_menuWillOpen:(NSNotification *)notification;
- (void)_menuDidClose:(NSNotification *)notification;

@end

@implementation CFStatusItemView

- (id)initWithStatusBarItem:(NSStatusItem *)statusItem
{
    self = [super initWithFrame:NSZeroRect];
    if(self) {
        [self setStatusItem:statusItem];
    }
    return self;
}

- (void)setImage:(NSImage *)image
{
    if(_image != image)
    {
        _image = image;
    }
    [self setNeedsDisplay];
}

- (void)setAlternateImage:(NSImage *)alternateImage
{
    if(_alternateImage != alternateImage)
    {
        _alternateImage = alternateImage;
    }
    [self setNeedsDisplay];
}

- (void)drawRect:(NSRect)dirtyRect
{
    BOOL highlighted = _isMouseDown || _isMenuVisible;
    [_statusItem drawStatusBarBackgroundInRect:[self bounds] withHighlight:highlighted];
    if (highlighted)
    {
        [self _drawImage:_alternateImage centeredInRect:dirtyRect];
    }
    else
    {
        [self _drawImage:_image centeredInRect:dirtyRect];
    }
}

- (void)mouseDown:(NSEvent *)theEvent
{
    _isMouseDown = YES;
    [self setNeedsDisplay];
}

- (void)mouseUp:(NSEvent *)theEvent
{
    if(!_isMouseDown)
    {
        return;
    }
    if([theEvent modifierFlags] & NSControlKeyMask)
    {
        [self _popUpRightMenu];
    }
    else
    {
        [NSApp sendAction:_action to:_target from:self];
    }
    
    _isMouseDown = NO;
    [self setNeedsDisplay];
}

- (void)rightMouseDown:(NSEvent *)theEvent
{
    _isMouseDown = YES;
    [self setNeedsDisplay];
}

- (void)rightMouseUp:(NSEvent *)theEvent
{
    if(!_isMouseDown)
    {
        return;
    }
    [self _popUpRightMenu];
    
    _isMouseDown = NO;
    [self setNeedsDisplay];
}

- (void)_drawImage:(NSImage *)image centeredInRect:(NSRect)rect{
    NSRect imageRect = NSMakeRect((CGFloat)round(rect.size.width*0.5f-image.size.width*0.5f),
                                  (CGFloat)round(rect.size.height*0.5f-image.size.height*0.5f),
                                  image.size.width,
                                  image.size.height);
    imageRect.origin.y ++;
    [image drawInRect:imageRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0f];
}

- (void)_popUpRightMenu
{
    if(_rightMenu)
    {
        [_statusItem popUpStatusItemMenu:_rightMenu];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_menuWillOpen:)
                                                     name:NSMenuDidBeginTrackingNotification
                                                   object:_rightMenu];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_menuDidClose:)
                                                     name:NSMenuDidEndTrackingNotification
                                                   object:_rightMenu];
    }
}

- (void)_menuWillOpen:(NSNotification *)notification
{
    _isMenuVisible = YES;
    [self setNeedsDisplay];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSMenuDidBeginTrackingNotification object:_rightMenu];
}

- (void)_menuDidClose:(NSNotification *)notification
{
    _isMenuVisible = NO;
    [self setNeedsDisplay];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSMenuDidEndTrackingNotification object:_rightMenu];
}

@end
