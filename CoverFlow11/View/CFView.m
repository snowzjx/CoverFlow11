//
//  CFView.m
//  CoverFlow11
//
//  Created by Snow on 12-12-14.
//  Copyright (c) 2012年 Snow. All rights reserved.
//

#import "CFView.h"
#import "CFViewConstant.h"
#import "PerspectiveTransform3D.h"

@implementation CFView

- (void)awakeFromNib
{
    NSLog(@"CFView - Awake From Nib ...");
    [self initRootLayer];
    [self initTransformations];

}

- (void)initRootLayer
{
    NSLog(@"CFView - Initializint the Root Layer ...");
    rootLayer = [CALayer layer];
    CGColorRef blackColor = CGColorCreateGenericRGB(0.0f, 0.0f, 0.0f, 1.0f);
    [rootLayer setBackgroundColor:blackColor];
    [rootLayer setCornerRadius:ROOT_LAYER_CORNER_RADIUS];
    [self setLayer:rootLayer];
    [self setWantsLayer:YES];
    NSLog(@"CFView - Fniish Initializing the Root Layer.");
}

- (void)initTransformations
{
    NSLog(@"CFView - Initializint the Transformations ...");
    
    // Transform - Rotation for the cover left to the center
    leftTransform = CATransform3DMakePerspectiveRotation(COVER_FLOW_SIDE_ANGLE, 0.0f, 1.0f, 0.0f,CGPointMake(0.0f, 0.0f),COVER_FLOW_DISZ);
    
    // Transform - Rotation for the cover right to the center
    rightTransform = CATransform3DMakePerspectiveRotation(COVER_FLOW_SIDE_ANGLE, 0.0f, -1.0f, 0.0f,CGPointMake(0.0f, 0.0f),COVER_FLOW_DISZ);
    
    // Transform - Translation for the center cover
    ceterTransform = CATransform3DMakePerspectiveTranslation(0.0f, 0.0f, 100.0f, CGPointMake(0.0f, 0.0f), COVER_FLOW_DISZ);
    

    NSLog(@"CFView - Fniish Initializing the Transformations.");
}

- (void)setUpLayers
{
    NSLog(@"CFView - Setting Up Layers ...");
    
}

@end
