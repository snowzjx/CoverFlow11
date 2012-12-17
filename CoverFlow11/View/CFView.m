//
//  CFView.m
//  CoverFlow11
//
//  Created by Snow on 12-12-14.
//  Copyright (c) 2012年 Snow. All rights reserved.
//

#import "CFView.h"
#import "CFViewConstant.h"

@implementation CFView

- (void)awakeFromNib
{
    NSLog(@"CFView - Awake From Nib ...");
    [self setUpData];
    [self setUpTransforms];
    [self setUpLayers];
}

- (void)setUpData
{
    itemLayers = [[NSMutableArray alloc] init];
}

- (void)setUpLayers
{
    NSLog(@"CFView - Setting Up Layers ...");
    rootLayer = [CALayer layer];
    CGColorRef blackColor = CGColorCreateGenericRGB(0.0f, 0.0f, 0.0f, 1.0f);
    [rootLayer setBackgroundColor:blackColor];
    [rootLayer setCornerRadius:ROOT_LAYER_CORNER_RADIUS];
    [rootLayer setLayoutManager:[CAConstraintLayoutManager layoutManager]];
    [self setLayer:rootLayer];
    [self setWantsLayer:YES];
    
    cfLayer = [CALayer layer];
    [cfLayer setBounds:[rootLayer bounds]];
    [cfLayer addConstraint:[CAConstraint
                            constraintWithAttribute:kCAConstraintMidX
                            relativeTo:@"superlayer"
                            attribute:kCAConstraintMidX]];
    [cfLayer addConstraint:[CAConstraint
                            constraintWithAttribute:kCAConstraintMidY
                            relativeTo:@"superlayer"
                            attribute:kCAConstraintMidY]];
    [cfLayer setLayoutManager:[CAConstraintLayoutManager layoutManager]];
    [cfLayer setSublayerTransform:subTransform];
    [rootLayer addSublayer:cfLayer];

}

- (void)setUpTransforms
{
    NSLog(@"CFView - Setting Up Transformas ...");
    
    // Transform - Rotation for the cover left to the center.
    leftTransform = CATransform3DRotate(CATransform3DIdentity, COVER_FLOW_SIDE_ANGLE, 0.0f, 1.0f, 0.0f);
    
    // Transform - Rotation for the cover right to the center.
    rightTransform = CATransform3DRotate(CATransform3DIdentity, COVER_FLOW_SIDE_ANGLE, 0.0f, -1.0f, 0.0f);
    
    // Transform for all sub layers - Add Perspective.
    subTransform = CATransform3DIdentity;
    subTransform.m34 = -1/COVER_FLOW_DISZ;
    
    reflectionTransform = CATransform3DScale(CATransform3DIdentity, 1.0f, -1.0f, 1.0f);
}

- (void)layoutCoverFlow:(CALayer *) itemLayer atIndex:(NSInteger)index selectIndex:(NSInteger)selectedIndex animated:(BOOL)animated
{
    NSLog(@"CFView - Laying out Cover Flow Index At: %ld",index);
    CATransform3D trans;
    CGPoint position = CGPointMake([cfLayer bounds].size.width / 2, COVER_FLOW_POSITION_Y);
    CGFloat zPosition = COVER_FLOW_SIDE_ZDIS;
    
    if(index < selectedIndex)
    {
        position.x += (index - selectedIndex) * COVER_FLOW_SIDE_SPACING;
        trans = leftTransform;
    }
    else if(index == selectedIndex)
    {
        zPosition = COVER_FLOW_CENTER_ZIDS;
        trans = CATransform3DIdentity;
    }
    else if(index > selectedIndex)
    {
        position.x += (index - selectedIndex) * COVER_FLOW_SIDE_SPACING;
        trans = rightTransform;
    }
    
    if(position.x < - COVER_FLOW_BOUNDS || position.x > [cfLayer bounds].size.width + COVER_FLOW_BOUNDS)
    {
        [itemLayer removeFromSuperlayer];
    }
    else
    {
        if(![[cfLayer sublayers] containsObject:itemLayer])
        {
            [cfLayer addSublayer:itemLayer];
        }
    }

    [itemLayer setPosition:position];
    [itemLayer setZPosition:zPosition];
    [itemLayer setTransform:trans];
}

- (void)addImage:(NSImage *)image
{
    [itemLayers addObject:[self setUpItemLayerWithImage:image]];
}

- (void)layoutCoverFlowSelectedAt:(NSInteger)index animated:(BOOL)animated
{
    NSLog(@"CFView - Laying out Cover Flow Selected At: %ld ...",index);
    for (int i = 0; i < [itemLayers count]; i++)
    {
        [self layoutCoverFlow:[itemLayers objectAtIndex:i] atIndex:i selectIndex:index animated:animated];
    }
}

- (void)removeAllCoverFlows
{
    NSLog(@"CFView - Removing All Cover Flows ...");
    [[cfLayer sublayers] makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [itemLayers removeAllObjects];
}

- (CALayer *)setUpItemLayerWithImage:(NSImage *)image
{
    CALayer *itemRootLayer = [CALayer layer];
    [itemRootLayer setBounds:CGRectMake(0.0f, 0.0f, COVER_FLOW_ITEM_WIDTH, COVER_FLOW_ITEM_HEIGHT)];
    [itemRootLayer setLayoutManager:[CAConstraintLayoutManager layoutManager]];
    [itemRootLayer setAnchorPoint:CGPointMake(0.5f, 0.5f)];
    
    CAReplicatorLayer *replecatorLayer = [CAReplicatorLayer layer];
    [replecatorLayer setBounds:[itemRootLayer bounds]];
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
    
    [itemRootLayer addSublayer:replecatorLayer];
    
    
    CAGradientLayer *shadowLayer = [CAGradientLayer layer];
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
    
    [itemRootLayer addSublayer:shadowLayer];
    
    CALayer *imageLayer = [CALayer layer];
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
    return itemRootLayer;
}

@end
