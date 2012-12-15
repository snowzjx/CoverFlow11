//
//  PerspectiveTransform3D.m
//  CoverFlow11
//
//  Created by Snow on 12-12-15.
//  Copyright (c) 2012年 Snow. All rights reserved.
//

#import "PerspectiveTransform3D.h"

@implementation PerspectiveTransform3D

CATransform3D CATransform3DMakePerspective(CGPoint center, CGFloat disZ);
CATransform3D CATransform3DPerspect(CATransform3D t, CGPoint center, CGFloat disZ);

CATransform3D CATransform3DMakePerspectiveRotation(CGFloat angle, CGFloat x, CGFloat y, CGFloat z,CGPoint center, CGFloat disZ)
{
    CATransform3D transRotation = CATransform3DMakeRotation(angle, x, y, z);
    return CATransform3DPerspect(transRotation,center,disZ);
}

CATransform3D CATransform3DMakePerspectiveTranslation(CGFloat tx, CGFloat ty, CGFloat tz, CGPoint center, CGFloat disz)
{
    CATransform3D transTranslation = CATransform3DMakeTranslation(tx, ty, tz);
    return CATransform3DPerspect(transTranslation, center, disz);
}


CATransform3D CATransform3DMakePerspective(CGPoint center, CGFloat disZ)
{
    CATransform3D transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, 0);
    CATransform3D transBack = CATransform3DMakeTranslation(center.x, center.y, 0);
    CATransform3D scale = CATransform3DIdentity;
    scale.m34 = -1.0f/disZ;
    return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack);
}

CATransform3D CATransform3DPerspect(CATransform3D t, CGPoint center, CGFloat disZ)
{
    return CATransform3DConcat(t, CATransform3DMakePerspective(center, disZ));
}

@end
