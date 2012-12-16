//
//  CFItemView.h
//  CoverFlow11
//
//  Created by Snow on 12-12-15.
//  Copyright (c) 2012年 Snow. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface CFItemView : NSView
{
    // Layers
    CALayer *rootLayer;
    CAReplicatorLayer *replecatorLayer;
    CALayer *imageLayer;
    CAGradientLayer *shadowLayer;
    
    // Transforms
    CATransform3D reflectionTransform;
}

- (void)setUp;
- (void)setImage:(NSImage *)image;

@end
