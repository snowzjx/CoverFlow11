//
//  PerspectiveTransform3D.h
//  CoverFlow11
//
//  Created by Snow on 12-12-15.
//  Copyright (c) 2012年 Snow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PerspectiveTransform3D : NSObject

CATransform3D CATransform3DMakePerspectiveRotation(CGFloat angle, CGFloat x, CGFloat y, CGFloat z,CGPoint center, CGFloat disZ);
CATransform3D CATransform3DMakePerspectiveTranslation(CGFloat tx, CGFloat ty, CGFloat tz, CGPoint center, CGFloat disz);

@end
