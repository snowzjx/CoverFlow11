//
//  CFView.h
//  CoverFlow11
//
//  Created by Snow on 12-12-14.
//  Copyright (c) 2012年 Snow. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@class CFItemView;

@interface CFView : NSView
{
    // Layers
    CALayer *rootLayer;
    CALayer *cfLayer;
    
    // CATransform3D
    CATransform3D leftTransform;
    CATransform3D rightTransform;
    CATransform3D subTransform;
}

@property(strong) NSArray *cfItemViews;
@property(strong) NSNumber *selectedIndex;

// When the cfItemViews changed,
// please call setUpLayers:.
- (void)setUpLayers;

// When the selectedIndex has been set,
// call layoutCoverFlowAnimated:
// the animation will begin.
- (void)layoutCoverFlowsAnimated:(BOOL)animated;

@end
