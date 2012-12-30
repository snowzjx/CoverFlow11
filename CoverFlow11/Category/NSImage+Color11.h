//
//  NSImage+Color11.h
//  CoverFlow11
//
//  Created by Snow on 12-12-29.
//  Copyright (c) 2012年 Snow. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage (Color11)

+ (NSArray*)dominantsColorsFromImage:(NSImage *)image
                           threshold:(CGFloat)threshold
                      numberOfColors:(NSUInteger)numberOfColors;

+ (NSArray*)getRGBAsFromImage:(NSImage *)image
                          atX:(NSInteger)xx
                         andY:(NSInteger)yy
                        count:(NSInteger)count;

@end
