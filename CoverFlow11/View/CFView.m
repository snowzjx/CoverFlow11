//
//  CFView.m
//  CoverFlow11
//
//  Created by Snow on 12-12-14.
//  Copyright (c) 2012年 Snow. All rights reserved.
//

#import "CFView.h"
#import "CFItemView.h"
#import "CFViewConstant.h"

@implementation CFView

@synthesize cfItemViews,selectedIndex;

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
    [rootLayer setLayoutManager:[CAConstraintLayoutManager layoutManager]];
    [self setLayer:rootLayer];
    [self setWantsLayer:YES];
    NSLog(@"CFView - Fniish Initializing the Root Layer.");
}

- (void)initTransformations
{
    NSLog(@"CFView - Initializint the Transformations ...");
    
    // Transform - Rotation for the cover left to the center.
    leftTransform = CATransform3DRotate(CATransform3DIdentity, COVER_FLOW_SIDE_ANGLE, 0.0f, 1.0f, 0.0f);
    
    // Transform - Rotation for the cover right to the center.
    rightTransform = CATransform3DRotate(CATransform3DIdentity, COVER_FLOW_SIDE_ANGLE, 0.0f, -1.0f, 0.0f);
    
    // Transform for all sub layers - Add Perspective.
    subTransform = CATransform3DIdentity;
    subTransform.m34 = -0.01;
    
    NSLog(@"CFView - Fniish Initializing the Transformations.");
}

- (void)setUpLayers
{
    NSLog(@"CFView - Setting Up Layers ...");
    if(cfLayer != nil)
    {
        [cfLayer removeFromSuperlayer];
    }
    cfLayer = [CALayer layer];
    [cfLayer setBounds:CGRectMake(0.0f, 0.0f, rootLayer.bounds.size.width, rootLayer.bounds.size.height* 3/4)];
    [cfLayer addConstraint:[CAConstraint
                            constraintWithAttribute:kCAConstraintMidX
                            relativeTo:@"superlayer"
                            attribute:kCAConstraintMidX]];
    [cfLayer addConstraint:[CAConstraint
                            constraintWithAttribute:kCAConstraintMaxY
                            relativeTo:@"superlayer"
                            attribute:kCAConstraintMaxY]];
    [cfLayer setSublayerTransform:subTransform];
    [rootLayer addSublayer:cfLayer];
    
    for(CFItemView *itemView in cfItemViews)
    {
        CALayer *itemLayer = [itemView layer];
        [itemLayer setAnchorPoint:CGPointMake(0.5f, 0.0f)];
        [cfLayer addSublayer:itemLayer];
    }
    NSLog(@"CFView - Finished Setting Up Layers.");
}

- (void)layoutCoverFlowsAnimated:(BOOL)animated
{
    NSLog(@"CFView - Laying out Cover Flow ...");
    for(int i = 0; i < [cfItemViews count]; i++)
    {
        [self layoutCoverFlow:[cfItemViews objectAtIndex:i] atIndex:i selectIndex:[selectedIndex intValue] animated:YES];
    }
    NSLog(@"CFView - Finish Laying out Cover Flow.");
}

- (void)layoutCoverFlow:(CFItemView *) itemView atIndex:(NSInteger)index selectIndex:(NSInteger)theSelectedIndex animated:(BOOL)animated
{
    NSLog(@"CFView - Laying out Cover Flow index at: %ld",index);
    CATransform3D trans;
    CGPoint positionn = CGPointMake(cfLayer.bounds.size.width / 2, 0.0f);
    CGFloat zPosition = COVER_FLOW_SIDE_ZDIS;
    
    if(index < theSelectedIndex)
    {
        positionn.x += (index - theSelectedIndex) * COVER_FLOW_SIDE_SPACING;
        trans = leftTransform;
    }
    else if(index == theSelectedIndex)
    {
        zPosition = COVER_FLOW_CENTER_ZIDS;
        trans = CATransform3DIdentity;
    }
    else if(index > theSelectedIndex)
    {
        positionn.x += (index - theSelectedIndex) * COVER_FLOW_SIDE_SPACING;
        trans = rightTransform;
    }
        
    [[itemView layer] setPosition:positionn];
    [[itemView layer] setZPosition:zPosition];
    [[itemView layer] setTransform:trans];
}

@end
