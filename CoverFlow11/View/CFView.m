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
- (void)_insertItemLayer:(NSString *)imageKey;

- (void)_loadArtworkInto:(CALayer *)layer;
- (void)_removeArtworkFrom:(CALayer *)layer;
- (NSImage *)_resizeImage:(NSImage *)image;


- (CGPoint)_positionOfSelectedItem;
- (NSInteger)_indexOfItemAtPoint:(CGPoint)point;
- (NSRect)_rectOfItemAtIndex:(NSInteger)index;

- (void)_selectedLayerClicked;
- (void)_selectedLayerDoubleClicked;

@end

@implementation CFView
@synthesize content = _content,selectedIndex = _selectedIndex;

NSString * const selectedCoverDoubleClickedNotification = @"CF_Selected_Cover_Double_Clicked";
NSString * const selectedCoverClickedNotification = @"CF_Selected_Cover_Clicked";

#pragma mark awakeFromNib
- (void)awakeFromNib
{
    [self setWantsLayer:YES];
    [self _setUpTransforms];
    [self _setUpLayers];
}

#pragma mark Property methods
- (void)setContent:(NSArray *)content
{
    if([_content isEqualToArray:content])
    {
        return;
    }
    _content = content;
    [[_scrollLayer sublayers] makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    for(NSString *imageKey in _content)
    {
        [self _insertItemLayer:imageKey];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
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
    [CATransaction setAnimationDuration:COVER_FLOW_ANIMATION_TIME_INTERVAL];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.4f :0.95f :0.75f :0.95f]];
    [_scrollLayer layoutIfNeeded];
    [_scrollLayer scrollToPoint:[self _positionOfSelectedItem]];
}

#pragma mark NSEvent methods
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
    switch ([theEvent keyCode]) {
        case LEFT_ARROW_KEY_CODE:
            [self setSelectedIndex:[self selectedIndex] + 1];
            break;
        case RIGHT_ARROW_KEY_CODE:
            [self setSelectedIndex:[self selectedIndex] - 1];
        default:
            [super keyDown:theEvent];
            break;
    }
}

- (void)mouseDown:(NSEvent *)theEvent
{
    NSPoint mousePoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    NSInteger selectedIndex = [self _indexOfItemAtPoint:mousePoint];
    if(selectedIndex != NSNotFound)
    {
        if (selectedIndex == _selectedIndex)
        {
            if([theEvent clickCount] == 2)
            {
                [NSRunLoop cancelPreviousPerformRequestsWithTarget:self selector:@selector(_selectedLayerClicked) object:nil];
                [self _selectedLayerDoubleClicked];
            }
            else
            {
                [self performSelector:@selector(_selectedLayerClicked) withObject:nil afterDelay:[NSEvent doubleClickInterval]];
            }
        }
        else
        {
            [self setSelectedIndex:selectedIndex];
        }
    }
}

#pragma mark Private methods
- (void)_setUpLayers
{
    _rootLayer = [CALayer layer];
    [_rootLayer setName:@"RootLayer"];
    [_rootLayer setBackgroundColor:CGColorGetConstantColor(kCGColorBlack)];
    [_rootLayer setCornerRadius:ROOT_LAYER_CORNER_RADIUS];
    [_rootLayer setLayoutManager:[CAConstraintLayoutManager layoutManager]];
    [self setLayer:_rootLayer];

    _coverFlowLayer = [CALayer layer];
    [_coverFlowLayer setName:@"CoverFlowLayer"];
    [_coverFlowLayer addConstraint:[CAConstraint
                            constraintWithAttribute:kCAConstraintWidth
                            relativeTo:@"superlayer"
                            attribute:kCAConstraintWidth]];
    [_coverFlowLayer addConstraint:[CAConstraint
                            constraintWithAttribute:kCAConstraintHeight
                            relativeTo:@"superlayer"
                            attribute:kCAConstraintHeight]];
    [_coverFlowLayer addConstraint:[CAConstraint
                            constraintWithAttribute:kCAConstraintMidX
                            relativeTo:@"superlayer"
                            attribute:kCAConstraintMidX]];
    [_coverFlowLayer addConstraint:[CAConstraint
                            constraintWithAttribute:kCAConstraintMidY
                            relativeTo:@"superlayer"
                            attribute:kCAConstraintMidY]];
    [_rootLayer addSublayer:_coverFlowLayer];
    
    _scrollLayer = [CAScrollLayer layer];
    [_scrollLayer setName:@"ScrollLayer"];
    [_scrollLayer setScrollMode:kCAScrollHorizontally];
    [_scrollLayer setAutoresizingMask:kCALayerWidthSizable | kCALayerHeightSizable];
    [_scrollLayer setLayoutManager:self];
    [_scrollLayer setSublayerTransform:_subLayerTransform];
    [_coverFlowLayer addSublayer:_scrollLayer];
}

- (void)_setUpTransforms
{    
    CATransform3D scaleTransform = CATransform3DScale(CATransform3DIdentity, COVER_FLOW_SIDE_SCALE, 1.0f, 1.0f);
    
    // Transform - Rotation for the cover left to the center.
    _leftTransform = CATransform3DRotate(scaleTransform, COVER_FLOW_SIDE_ANGLE, 0.0f, 1.0f, 0.0f);
    
    // Transform - Rotation for the cover right to the center.
    _rightTransform = CATransform3DRotate(scaleTransform, COVER_FLOW_SIDE_ANGLE, 0.0f, -1.0f, 0.0f);
    
    // Transform for all sub layers - Add Perspective.
    _subLayerTransform = CATransform3DIdentity;
    _subLayerTransform.m34 = -1/COVER_FLOW_DISZ;
    
    _reflectionTransform = CATransform3DScale(CATransform3DIdentity, 1.0f, -1.0f, 1.0f);
}

- (void)_insertItemLayer:(NSString *)imageKey;
{
    CALayer *itemRootLayer = [CALayer layer];
    [itemRootLayer setName:@"ItemRootLayer"];
    [itemRootLayer setBounds:CGRectMake(0.0f, 0.0f, COVER_FLOW_ITEM_WIDTH, COVER_FLOW_ITEM_HEIGHT)];
    [itemRootLayer setLayoutManager:[CAConstraintLayoutManager layoutManager]];
    [itemRootLayer setAnchorPoint:CGPointMake(0.5f, 0.5f)];
    [itemRootLayer setValue:[NSNumber numberWithInteger:[[_scrollLayer sublayers] count]] forKey:@"Index"];
    [itemRootLayer setValue:[NSNumber numberWithBool:NO] forKey:@"HasImage"];
    [itemRootLayer setValue:imageKey forKey:@"ImageKey"];
    
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
    [replecatorLayer setInstanceTransform:_reflectionTransform];
    [itemRootLayer addSublayer:replecatorLayer];
    
    CALayer *imageLayer = [CALayer layer];
    [imageLayer setName:@"ImageLayer"];
    [imageLayer setBounds:CGRectMake(0.0f, 0.0f, COVER_FLOW_ITEM_WIDTH, COVER_FLOW_ITEM_HEIGHT / 2)];
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
    [_scrollLayer addSublayer:itemRootLayer];
    
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
}

- (void)_loadArtworkInto:(CALayer *)layer
{
    BOOL hasImage = [[layer valueForKey:@"HasImage"] boolValue];
    if(!hasImage)
    {
        NSString *imageKey = [layer valueForKey:@"ImageKey"];
        NSImage *image = [_imageDataSourceDelegate loadImageFromKey:imageKey];
        CAReplicatorLayer *replecatorLayer = [[layer sublayers] objectAtIndex:0];
        CALayer *imageLayer = [[replecatorLayer sublayers] objectAtIndex:0];
        [imageLayer setContents:[self _resizeImage:image]];
        image = nil;
        [layer setValue:[NSNumber numberWithBool:YES] forKey:@"HasImage"];
    }
}

- (void)_removeArtworkFrom:(CALayer *)layer
{
    BOOL hasImage = [[layer valueForKey:@"HasImage"] boolValue];
    if(hasImage)
    {
        CAReplicatorLayer *replecatorLayer = [[layer sublayers] objectAtIndex:0];
        CALayer *imageLayer = [[replecatorLayer sublayers] objectAtIndex:0];
        [imageLayer setContents:nil];
        [layer setValue:[NSNumber numberWithBool:NO] forKey:@"HasImage"];
    }
}

- (NSImage *)_resizeImage:(NSImage *)image
{
    NSImage *newImage = [[NSImage alloc] initWithSize:NSMakeSize(COVER_FLOW_ITEM_WIDTH, COVER_FLOW_ITEM_WIDTH * image.size.height / image.size.width)];
    
    [newImage lockFocus];
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithGraphicsPort:context flipped:NO]];
    [image drawInRect:NSMakeRect(0.0, 0.0, newImage.size.width, newImage.size.height) fromRect:NSMakeRect(0.0, 0.0, image.size.width, image.size.height)
            operation:NSCompositeCopy fraction:1.0f];
    [newImage unlockFocus];
    
    return newImage;
}

- (CGPoint)_positionOfSelectedItem
{
    return CGPointMake(_selectedIndex * COVER_FLOW_SPACING , COVER_FLOW_POSITION_Y);
}

- (NSInteger)_indexOfItemAtPoint:(CGPoint)point
{
    if(NSPointInRect(point, [self _rectOfItemAtIndex:_selectedIndex]))
    {
        return _selectedIndex;
    }
    NSInteger index = _selectedIndex - 1;
    while(index >= _selectedIndex - COVER_FLOW_IMAGE_INDEX_DELTA_VALUE && index >= 0)
    {
        if(NSPointInRect(point, [self _rectOfItemAtIndex:index]))
        {
            return index;
        }
        index --;
    }
    index = _selectedIndex + 1;
    while(index <= _selectedIndex + COVER_FLOW_IMAGE_INDEX_DELTA_VALUE && index <= [_content count] - 1)
    {
        if(NSPointInRect(point, [self _rectOfItemAtIndex:index]))
        {
            return index;
        }
        index ++;
    }
    return NSNotFound;
}

- (NSRect)_rectOfItemAtIndex:(NSInteger)index
{
    if(index < 0 || index > [_content count] - 1)
    {
        return NSZeroRect;
    }
    CALayer *layer = [[_scrollLayer sublayers] objectAtIndex:index];
    CALayer *subLayer = [[layer sublayers] objectAtIndex:0];
    CALayer *imageLayer = [[subLayer sublayers] objectAtIndex:0];
    CGRect frame = [imageLayer convertRect:CGRectMake(0, 0 , COVER_FLOW_ITEM_WIDTH, COVER_FLOW_ITEM_HEIGHT / 2) toLayer:_rootLayer];
    return NSRectFromCGRect(frame);
}

- (void)_selectedLayerDoubleClicked
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:_selectedIndex] forKey:@"SelectedIndex"];
    [[NSNotificationCenter defaultCenter] postNotificationName:selectedCoverDoubleClickedNotification object:self userInfo:userInfo];
}

- (void)_selectedLayerClicked
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:_selectedIndex] forKey:@"SelectedIndex"];
    [[NSNotificationCenter defaultCenter] postNotificationName:selectedCoverClickedNotification object:self userInfo:userInfo];
}

#pragma mark Layout manager protocol
- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    for(CALayer *subLayer in [layer sublayers])
    {
        NSInteger index  = [[subLayer valueForKey:@"Index"] integerValue];
        
        CATransform3D trans;
        CGPoint position = CGPointMake(index * COVER_FLOW_SPACING + COVER_FLOW_POSITION_LEFT_OFFSET, COVER_FLOW_POSITION_Y);
        CGFloat zPosition = COVER_FLOW_SIDE_ZDIS;
        
        if(index < _selectedIndex)
        {
            position.x -= COVER_FLOW_SIDE_SPACING_OFFST;
            trans = _leftTransform;
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
            trans = _rightTransform;
            zPosition -= ABS(_selectedIndex - index) * COVER_FLOW_SIDE_ZDIS_FADE;
        }
        
        /* -- Loads the image when necessray --*/
        if(ABS(index - _selectedIndex) <= COVER_FLOW_IMAGE_INDEX_DELTA_VALUE)
        {
            [self _loadArtworkInto:subLayer];
        }
        else
        {
            [self _removeArtworkFrom:subLayer];
        }
        
        /* -- Remove unused layers from cflayer -- */
        if(ABS(index - _selectedIndex) >= COVER_FLOW_RENDER_INDEX_DELTA_VALUE)
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
