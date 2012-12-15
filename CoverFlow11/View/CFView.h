//
//  CFView.h
//  CoverFlow11
//
//  Created by Snow on 12-12-14.
//  Copyright (c) 2012年 Snow. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface CFView : NSView
{
    // Layers
    CALayer *rootLayer;
    
    // CATransform3D
    CATransform3D leftTransform;
    CATransform3D rightTransform;
    CATransform3D ceterTransform;
}

- (void) setUpLayers;

@end
