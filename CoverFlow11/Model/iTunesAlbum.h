//
//  iTunesAlbum.h
//  CoverFlow11
//
//  Created by Snow on 12-12-15.
//  Copyright (c) 2012年 Snow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iTunesAlbum : NSObject

@property(strong) NSString *albumName;
@property(strong) NSImage *albumArtWork;
@property(strong) NSMutableArray *albumTracks;

@end
