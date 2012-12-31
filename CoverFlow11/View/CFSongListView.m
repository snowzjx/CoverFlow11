//
//  CFSongListView.m
//  CoverFlow11
//
//  Created by Snow on 12-12-30.
//  Copyright (c) 2012年 Snow. All rights reserved.
//

#import "CFSongListView.h"
#import "CFSongListViewConstant.h"

@interface CFSongListView ()

- (void)_setUpLayers;
- (void)_insertSongListItemLayer:(NSString *)track;
- (void)_setScrollIndex:(NSInteger) index;
- (NSInteger)_indexOfItemAtPoint:(NSPoint) mousePoint;
- (NSRect)_rectOfItemAtIndex:(NSInteger) index;
- (void)_setSelectedIndex:(NSInteger) index;
- (void)_selectedIndexDoubleClicked;

@end

@implementation CFSongListView

NSString *const selectedSongDoubleClickedNotification = @"CF_Selected_Song_Double_Clicked";

- (void)awakeFromNib
{
    [self setWantsLayer:YES];
    [self _setUpLayers];
}

- (void)cfSongListShow
{
    [_contentLayer setBackgroundColor:[_backgroundColor CGColor]];
    [_titleLayer setString:_album];
    [_titleLayer setForegroundColor:[_primaryTextColor CGColor]];
    for(NSString *track in _tracks)
    {
        [self _insertSongListItemLayer:track];
    }
    _selectedIndex = NSNotFound;
}

- (void)cfSongListClose
{
    [[_scrollLayer sublayers] makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self _setScrollIndex:0];
}

- (void)scrollWheel:(NSEvent *)theEvent
{
    if (fabs([theEvent deltaX]) > SCROLLER_WHEEL_MINIMAL_DELTA_VALUE) {
		if ([theEvent deltaX] > 0) {
			[self _setScrollIndex:(_scrollIndex - 1)];
		} else {
			[self _setScrollIndex:(_scrollIndex + 1)];
		}
	}
}
- (void)mouseDown:(NSEvent *)theEvent
{
    NSPoint mousePoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    NSInteger selectedIndex = [self _indexOfItemAtPoint:mousePoint];
    [self _setSelectedIndex:selectedIndex];
    if([theEvent clickCount] == 2 && _selectedIndex != NSNotFound)
    {
        [self _selectedIndexDoubleClicked];
    }
}

- (void)_setUpLayers
{
    _rootLayer = [CALayer layer];
    [_rootLayer setName:@"RootLayer"];
    [_rootLayer setLayoutManager:[CAConstraintLayoutManager layoutManager]];
    [self setLayer:_rootLayer];
    
    // Set Up Background Layer
    _contentLayer = [CALayer layer];
    [_contentLayer setCornerRadius:SONGLIST_CONTENT_CORNER_RADIUS];
    [_contentLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintWidth
                                                               relativeTo:@"superlayer"
                                                                attribute:kCAConstraintWidth
                                                                   offset:-4.0f]];
    [_contentLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintHeight
                                                               relativeTo:@"superlayer"
                                                                attribute:kCAConstraintHeight
                                                                   offset:-4.0f]];
    [_contentLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidX
                                                               relativeTo:@"superlayer"
                                                                attribute:kCAConstraintMidX]];
    [_contentLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidY
                                                               relativeTo:@"superlayer"
                                                                attribute:kCAConstraintMidY]];
    [_contentLayer setLayoutManager:[CAConstraintLayoutManager layoutManager]];
    [_rootLayer addSublayer:_contentLayer];
    
    // Set Up Album Title Layer
    _titleLayer = [CATextLayer layer];
    [_titleLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinX
                                                          relativeTo:@"superlayer"
                                                           attribute:kCAConstraintMinX
                                                              offset:SONGLIST_TITLE_LEFT_OFFSET]];
    [_titleLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxY
                                                          relativeTo:@"superlayer"
                                                           attribute:kCAConstraintMaxY
                                                              offset:SONGLIST_TITLE_TOP_OFFSET]];
    [_titleLayer setFontSize:SONGLIST_TITLE_FONT_SIZE];
    [_titleLayer setName:@"TitleLayer"];
    [_titleLayer setFont:@"Arial Black"];
    [_contentLayer addSublayer:_titleLayer];
    
    // Set Up Scroll Layer
    _scrollLayer = [CAScrollLayer layer];
    [_scrollLayer setScrollMode:kCAScrollHorizontally];
    [_scrollLayer setAutoresizingMask:kCALayerWidthSizable | kCALayerHeightSizable];
    [_contentLayer addSublayer:_scrollLayer];
}

- (void)_insertSongListItemLayer:(NSString *)track
{
    NSInteger index = [[_scrollLayer sublayers] count];
    CALayer *songListItemLayer = [CALayer layer];
    [songListItemLayer setLayoutManager:[CAConstraintLayoutManager layoutManager]];
    [songListItemLayer setBounds:CGRectMake(0.0f, 0.0f, SONGLIST_ITEM_WIDTH, SONGLIST_ITEM_HEIGHT)];
    [songListItemLayer setCornerRadius:SONGLIST_ITEM_CORNER_RADIUS];
    
    CATextLayer *numberLayer = [CATextLayer layer];
    [numberLayer setName:@"NumberLayer"];
    [numberLayer setString:[NSString stringWithFormat:@"%ld",index + 1]];
    [numberLayer setForegroundColor:[_secondaryTextColor CGColor]];
    [numberLayer setFontSize:SONGLIST_ITEM_FONT_SIZE];
    [numberLayer setFont:@"Arial Black"];
    [numberLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinX
                                                          relativeTo:@"superlayer"
                                                           attribute:kCAConstraintMinX
                                                              offset:10.0f]];
    [numberLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidY
                                                          relativeTo:@"superlayer"
                                                           attribute:kCAConstraintMidY]];
 
    CATextLayer *trackTitleLayer = [CATextLayer layer];
    [trackTitleLayer setString:track];
    [trackTitleLayer setForegroundColor:[_primaryTextColor CGColor]];
    [trackTitleLayer setFontSize:SONGLIST_ITEM_FONT_SIZE];
    [trackTitleLayer setFont:@"Arial Black"];
    [trackTitleLayer setTruncationMode:kCATruncationEnd];
    [trackTitleLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinX
                                                              relativeTo:@"superlayer"
                                                               attribute:kCAConstraintMinX
                                                                  offset:35.0f]];
    [trackTitleLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxX
                                                              relativeTo:@"superlayer"
                                                               attribute:kCAConstraintMaxX
                                                                  offset:-10.0f]];
    [trackTitleLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidY
                                                              relativeTo:@"superlayer"
                                                               attribute:kCAConstraintMidY]];

    [songListItemLayer addSublayer:numberLayer];
    [songListItemLayer addSublayer:trackTitleLayer];
        
    CGPoint position;
    if(index % 2 == 0)
    {
        position.x = index * SONGLIST_ITEM_SPACING + SONGLIST_ITEM_LEFT_OFFEST + SONGLIST_ITEM_WIDTH / 2;
        position.y = SONGLIST_ITEM_HEIGHT_EVEN;
    }
    else
    {
        position.x = (index - 1) * SONGLIST_ITEM_SPACING + SONGLIST_ITEM_LEFT_OFFEST + SONGLIST_ITEM_WIDTH / 2;
        position.y = SONGLIST_ITEM_HEIGHT_ODD;
    }
    [songListItemLayer setPosition:position];
    [_scrollLayer addSublayer:songListItemLayer];
}

- (void)_setScrollIndex:(NSInteger)index
{
    if(index < 0 )
    {
        return;
    }
    else if(index > ([_tracks count] % 2 == 0 ? [_tracks count] / 2 - 1 : [_tracks count] / 2 ))
    {
        return;
    }
    else
    {
        _scrollIndex = index;
    }
    [CATransaction setAnimationDuration:SONGLIST_ANIMATION_TIME_INTERVAL];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.4f :0.95f :0.75f :0.95f]];
    [_scrollLayer scrollToPoint:CGPointMake(_scrollIndex * SONGLIST_ITEM_SPACING * 2, 0.0)];
}

- (NSInteger)_indexOfItemAtPoint:(NSPoint)mousePoint
{
    for(NSInteger index = _scrollIndex * 2 - 1; index <= _scrollIndex * 2 + 3; index ++)
    {
        if(NSPointInRect(mousePoint, [self _rectOfItemAtIndex:index]))
        {
            return index;
        }
    }
    return NSNotFound;
}

- (NSRect)_rectOfItemAtIndex:(NSInteger)index
{
    if(index < 0 || index > [_tracks count] - 1)
    {
        return NSZeroRect;
    }
    CALayer *layer = [[_scrollLayer sublayers] objectAtIndex:index];
    CGRect frame = [layer convertRect:CGRectMake(0.0f, 0.0f, SONGLIST_ITEM_WIDTH, SONGLIST_ITEM_HEIGHT) toLayer:_rootLayer];
    return NSRectFromCGRect(frame);
}

- (void)_setSelectedIndex:(NSInteger)index
{
    if(_selectedIndex != NSNotFound)
    {
        CALayer *layer = [[_scrollLayer sublayers] objectAtIndex:_selectedIndex];
        [layer setBackgroundColor:nil];
        CATextLayer *numberLayer = [[layer sublayers] objectAtIndex:0];
        [numberLayer setForegroundColor:[_secondaryTextColor CGColor]];
        CATextLayer *trackTitleLayer = [[layer sublayers] objectAtIndex:1];
        [trackTitleLayer setForegroundColor:[_primaryTextColor CGColor]];
    }
    if(index != NSNotFound)
    {
        CALayer *layer = [[_scrollLayer sublayers] objectAtIndex:index];
        [layer setBackgroundColor:[_secondaryTextColor CGColor]];
        [[layer sublayers] makeObjectsPerformSelector:@selector(setForegroundColor:) withObject:(__bridge id)[_backgroundColor CGColor]];
    }
    _selectedIndex = index;
}

- (void)_selectedIndexDoubleClicked
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:_selectedIndex] forKey:@"SelectedIndex"];
    [[NSNotificationCenter defaultCenter] postNotificationName:selectedSongDoubleClickedNotification object:self userInfo:userInfo];
}

@end
