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
@end

@implementation CFSongListView

- (void)awakeFromNib
{
    [self setWantsLayer:YES];
    [self _setUpLayers];
}

- (void)showCFSongList
{
    [_contentLayer setBackgroundColor:[_backgroundColor CGColor]];
    [_titleLayer setString:_album];
    [_titleLayer setForegroundColor:[_primaryTextColor CGColor]];
    [[_scrollLayer sublayers] makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    for(NSString *track in _tracks)
    {
        [self _insertSongListItemLayer:track];
    }
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
    
    CATextLayer *numberLayer = [CATextLayer layer];
    [numberLayer setName:@"NumberLayer"];
    [numberLayer setString:[NSString stringWithFormat:@"%ld .",index + 1]];
    [numberLayer setForegroundColor:[_secondaryTextColor CGColor]];
    [numberLayer setFontSize:SONGLIST_ITEM_FONT_SIZE];
    [numberLayer setFont:@"Arial"];
    [numberLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinX
                                                          relativeTo:@"superlayer"
                                                           attribute:kCAConstraintMinX]];
    [numberLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidY
                                                          relativeTo:@"superlayer"
                                                           attribute:kCAConstraintMidY]];
 
    CATextLayer *trackTitleLayer = [CATextLayer layer];
    [trackTitleLayer setString:track];
    [trackTitleLayer setForegroundColor:[_primaryTextColor CGColor]];
    [trackTitleLayer setFontSize:SONGLIST_ITEM_FONT_SIZE];
    [trackTitleLayer setFont:@"Arial"];
    [trackTitleLayer setWrapped:YES];
    [trackTitleLayer setTruncationMode:kCATruncationStart];
    [trackTitleLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinX
                                                              relativeTo:@"superlayer"
                                                               attribute:kCAConstraintMinX
                                                                  offset:20.0f]];
    [trackTitleLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxX
                                                              relativeTo:@"superlayer"
                                                               attribute:kCAConstraintMaxX]];
    [trackTitleLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidY
                                                              relativeTo:@"superlayer"
                                                               attribute:kCAConstraintMidY
                                                                  offset:1.5f]];

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
        position.x = (index - 1) * SONGLIST_ITEM_SPACING + SONGLIST_ITEM_LEFT_OFFEST + SONGLIST_ITEM_LEFT_OFFEST + SONGLIST_ITEM_WIDTH / 2;
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


@end
