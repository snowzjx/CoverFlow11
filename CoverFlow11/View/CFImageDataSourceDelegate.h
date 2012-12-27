//
//  CFImageDataSourceDelegate.h
//  CoverFlow11
//
//  Created by Snow on 12-12-25.
//  Copyright (c) 2012年 Snow. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CFImageDataSourceDelegate <NSObject>

- (NSImage *)loadImageFromKey:(NSString *)imageKey;

@end
