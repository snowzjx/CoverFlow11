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

- (void)setUp
{
    [self setupTransforms];
    [self setUpLayers];
}

- (void)setUpLayers
{
    rootLayer = [CALayer layer];
    [rootLayer setBounds:[self bounds]];
    [rootLayer setLayoutManager:[CAConstraintLayoutManager layoutManager]];
    [self setLayer:rootLayer];
    [self setWantsLayer:YES];
    [rootLayer setAnchorPoint:CGPointMake(0.5f, 0.5f)];
    
    replecatorLayer = [CAReplicatorLayer layer];
    [replecatorLayer setBounds:[rootLayer bounds]];
    [replecatorLayer addConstraint:[CAConstraint
                                    constraintWithAttribute:kCAConstraintMidX
                                    relativeTo:@"superlayer"
                                    attribute:kCAConstraintMidX]];
    [replecatorLayer addConstraint:[CAConstraint
                                    constraintWithAttribute:kCAConstraintMidY
                                    relativeTo:@"superlayer"
                                    attribute:kCAConstraintMidY]];
    [replecatorLayer setLayoutManager:[CAConstraintLayoutManager layoutManager]];
    [replecatorLayer setInstanceCount:2];
    [replecatorLayer setInstanceTransform:reflectionTransform];
    
    [rootLayer addSublayer:replecatorLayer];
    
    
    shadowLayer = [CAGradientLayer layer];
    [shadowLayer setBounds:CGRectMake(0.0f, 0.0f, COVER_FLOW_ITEM_WIDTH, COVER_FLOW_ITEM_HEIGHT / 2)];
    [shadowLayer addConstraint:[CAConstraint
                                constraintWithAttribute:kCAConstraintMinY
                                relativeTo:@"superlayer"
                                attribute:kCAConstraintMinY]];
    [shadowLayer addConstraint:[CAConstraint
                                constraintWithAttribute:kCAConstraintMidX
                                relativeTo:@"superlayer"
                                attribute:kCAConstraintMidX]];
    [shadowLayer setColors:[NSArray arrayWithObjects:
                            (__bridge id)(CGColorCreateGenericRGB(0.0f, 0.0f, 0.0f, 0.5f)),
                            CGColorCreateGenericRGB(0.0f, 0.0f, 0.0f, 1.0f),nil]];
    [shadowLayer setStartPoint:CGPointMake(0.5f, 1.0f)];
    [shadowLayer setEndPoint:CGPointMake(0.5f, 0.3f)];
    
    [rootLayer addSublayer:shadowLayer];
}

- (void)setupTransforms
{
    reflectionTransform = CATransform3DScale(CATransform3DIdentity, 1.0f, -1.0f, 1.0f);
}
- (void)setImage:(NSImage *)image
{
    imageLayer = [CALayer layer];
    [imageLayer setBounds:CGRectMake(0.0f, 0.0f, COVER_FLOW_ITEM_WIDTH, COVER_FLOW_ITEM_HEIGHT / 2)];
    [imageLayer setContents:image];
    [imageLayer setContentsGravity:kCAGravityBottom];
    [imageLayer setContentsGravity:kCAGravityResizeAspect];
    [imageLayer addConstraint:[CAConstraint
                               constraintWithAttribute:kCAConstraintMaxY
                               relativeTo:@"superlayer"
                               attribute:kCAConstraintMaxY]];
    [imageLayer addConstraint:[CAConstraint
                               constraintWithAttribute:kCAConstraintMidX
                               relativeTo:@"superlayer"
                               attribute:kCAConstraintMidX]];
    [replecatorLayer addSublayer:imageLayer];
}

@end
