//
//  CFView.m
//  CoverFlow11
//
//  Created by Snow on 12-12-14.
//  Copyright (c) 2012年 Snow. All rights reserved.
//

#import "CFView.h"
#import "CFViewConstant.h"

@interface CFView ()

- (void)_setUpLayers;
- (void)_setUpTransforms;
- (void)_insertItemLayer:(NSImage *)image;
- (CGPoint)_positionOfSelectedItem;

@end

@implementation CFView
@synthesize content = _content,selectedIndex = _selectedIndex;

- (void)awakeFromNib
{
    NSLog(@"CFView - Awake From Nib ...");
    [self setWantsLayer:YES];
    [self _setUpTransforms];
    [self _setUpLayers];
}

- (void)setContent:(NSArray *)content
{
    NSLog(@"CFView - Setting Content ...");
    if([_content isEqualToArray:content])
    {
        return;
    }
    _content = content;
    [[scrollLayer sublayers] makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    for(NSImage *image in _content)
    {
        [self _insertItemLayer:image];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    NSLog(@"CFView - Selected Index Been Set With Value: %ld !",selectedIndex);
    if(selectedIndex < 0)
    {
        return;
    }
    else if(selectedIndex > [_content count] - 1)
    {
        return;
    }
    else
    {
        _selectedIndex = selectedIndex;
    }
    _selectedIndex = selectedIndex;
    [CATransaction setAnimationDuration:COVER_FLOW_ANIMATION_TIME_INTERVAL];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.4f :0.95f :0.75f :0.95f]];
    [scrollLayer layoutIfNeeded];
    [scrollLayer scrollToPoint:[self _positionOfSelectedItem]];
}

- (void)scrollWheel:(NSEvent *)theEvent
{
    if (fabs([theEvent deltaX]) > SCROLLER_WHEEL_MINIMAL_DELTA_VALUE) {
		if ([theEvent deltaX] > 0) {
			[self setSelectedIndex:(self.selectedIndex - 1)];
		} else {
			[self setSelectedIndex:(self.selectedIndex + 1)];
		}
	}
}

- (void)keyDown:(NSEvent *)theEvent
{
    
}

- (void)_setUpLayers
{
    NSLog(@"CFView - Setting Up Layers ...");
    rootLayer = [CALayer layer];
    [rootLayer setName:@"RootLayer"];
    [rootLayer setBackgroundColor:CGColorGetConstantColor(kCGColorBlack)];
    [rootLayer setCornerRadius:ROOT_LAYER_CORNER_RADIUS];
    [rootLayer setLayoutManager:[CAConstraintLayoutManager layoutManager]];
    [self setLayer:rootLayer];

    cfLayer = [CALayer layer];
    [cfLayer setName:@"CoverFlowLayer"];
    [cfLayer addConstraint:[CAConstraint
                            constraintWithAttribute:kCAConstraintWidth
                            relativeTo:@"superlayer"
                            attribute:kCAConstraintWidth]];
    [cfLayer addConstraint:[CAConstraint
                            constraintWithAttribute:kCAConstraintHeight
                            relativeTo:@"superlayer"
                            attribute:kCAConstraintHeight]];
    [cfLayer addConstraint:[CAConstraint
                            constraintWithAttribute:kCAConstraintMidX
                            relativeTo:@"superlayer"
                            attribute:kCAConstraintMidX]];
    [cfLayer addConstraint:[CAConstraint
                            constraintWithAttribute:kCAConstraintMidY
                            relativeTo:@"superlayer"
                            attribute:kCAConstraintMidY]];
    [rootLayer addSublayer:cfLayer];
    
    scrollLayer = [CAScrollLayer layer];
    [scrollLayer setName:@"ScrollLayer"];
    [scrollLayer setScrollMode:kCAScrollHorizontally];
    [scrollLayer setAutoresizingMask:kCALayerWidthSizable | kCALayerHeightSizable];
    [scrollLayer setLayoutManager:self];
    [scrollLayer setSublayerTransform:subTransform];
    [cfLayer addSublayer:scrollLayer];
}

- (void)_setUpTransforms
{
    NSLog(@"CFView - Setting Up Transformas ...");
    
    CATransform3D scaleTransform = CATransform3DScale(CATransform3DIdentity, COVER_FLOW_SIDE_SCALE, 1.0f, 1.0f);
    
    // Transform - Rotation for the cover left to the center.
    leftTransform = CATransform3DRotate(scaleTransform, COVER_FLOW_SIDE_ANGLE, 0.0f, 1.0f, 0.0f);
    
    // Transform - Rotation for the cover right to the center.
    rightTransform = CATransform3DRotate(scaleTransform, COVER_FLOW_SIDE_ANGLE, 0.0f, -1.0f, 0.0f);
    
    // Transform for all sub layers - Add Perspective.
    subTransform = CATransform3DIdentity;
    subTransform.m34 = -1/COVER_FLOW_DISZ;
    
    reflectionTransform = CATransform3DScale(CATransform3DIdentity, 1.0f, -1.0f, 1.0f);
}

- (void)_insertItemLayer:(NSImage *)image
{
    CALayer *itemRootLayer = [CALayer layer];
    [itemRootLayer setBounds:CGRectMake(0.0f, 0.0f, COVER_FLOW_ITEM_WIDTH, COVER_FLOW_ITEM_HEIGHT)];
    [itemRootLayer setLayoutManager:[CAConstraintLayoutManager layoutManager]];
    [itemRootLayer setAnchorPoint:CGPointMake(0.5f, 0.5f)];
    [itemRootLayer setValue:[NSNumber numberWithInteger:[[scrollLayer sublayers] count]] forKey:@"index"];
    
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
    [scrollLayer addSublayer:itemRootLayer];
}

- (CGPoint)_positionOfSelectedItem
{
    return CGPointMake(_selectedIndex * COVER_FLOW_SPACING , COVER_FLOW_POSITION_Y);
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    NSLog(@"CFView - Layout Sub Layers ...");
    for(CALayer *subLayer in [layer sublayers])
    {
        NSInteger index  = [[subLayer valueForKey:@"index"] integerValue];
        CATransform3D trans;
        CGPoint position = CGPointMake(index * COVER_FLOW_SPACING + COVER_FLOW_POSITION_LEFT_OFFSET, COVER_FLOW_POSITION_Y);
        
        CGFloat zPosition = COVER_FLOW_SIDE_ZDIS;
        
        if(index < _selectedIndex)
        {
            position.x -= COVER_FLOW_SIDE_SPACING_OFFST;
            trans = leftTransform;
            zPosition -= ABS(_selectedIndex - index) * COVER_FLOW_SIDE_ZDIS_FADE;
        }
        else if(index == _selectedIndex)
        {
            zPosition = COVER_FLOW_CENTER_ZIDS;
            trans = CATransform3DIdentity;
        }
        else if(index > _selectedIndex)
        {
            position.x += COVER_FLOW_SIDE_SPACING_OFFST;
            trans = rightTransform;
            zPosition -= ABS(_selectedIndex - index) * COVER_FLOW_SIDE_ZDIS_FADE;
        }
        
        /* -- Remove unused layers from cflayer -- */
        if(ABS(index - _selectedIndex) >= COVER_FLOW_INDEX_DELTA_VALUE)
        {
            [subLayer setHidden:YES];
        }
        else
        {
            [subLayer setHidden:NO];
        }
        
        [subLayer setPosition:position];
        [subLayer setTransform:trans];
        [subLayer setZPosition:zPosition];
    }
}

@end
