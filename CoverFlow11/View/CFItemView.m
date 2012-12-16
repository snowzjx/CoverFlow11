//
//  CFItemView.m
//  CoverFlow11
//
//  Created by Snow on 12-12-15.
//  Copyright (c) 2012年 Snow. All rights reserved.
//

#import "CFItemView.h"
#import "CFViewConstant.h"


@implementation CFItemView

- (void)setUpLayers
{
    rootLayer = [CALayer layer];
    [rootLayer setBounds:[self bounds]];
    [rootLayer setLayoutManager:[CAConstraintLayoutManager layoutManager]];
    [self setLayer:rootLayer];
    [self setWantsLayer:YES];
}

- (void)setImage:(NSImage *)image
{
    imageLayer = [CALayer layer];
    [imageLayer setBounds:[rootLayer bounds]];
    [imageLayer setContents:image];
    [imageLayer setContentsGravity:kCAGravityResizeAspect];
    [imageLayer addConstraint:[CAConstraint
                               constraintWithAttribute:kCAConstraintMidY
                               relativeTo:@"superlayer"
                               attribute:kCAConstraintMidY]];
    [imageLayer addConstraint:[CAConstraint
                               constraintWithAttribute:kCAConstraintMidX
                               relativeTo:@"superlayer"
                               attribute:kCAConstraintMidX]];
    [rootLayer addSublayer:imageLayer];
}

@end
