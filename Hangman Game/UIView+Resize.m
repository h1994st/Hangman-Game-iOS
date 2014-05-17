//
//  UIView+Resize.m
//  Hangman Game
//
//  Created by Tom Hu on 5/17/14.
//  Copyright (c) 2014 Tom Hu. All rights reserved.
//

#import "UIView+Resize.h"

@implementation UIView (Resize)

#pragma mark -
#pragma mark Reset Origin
- (void)resetOriginX:(CGFloat)originX {
    CGRect frame = self.frame;
    frame.origin.x = originX;
    self.frame = frame;
}

- (void)resetOriginY:(CGFloat)originY {
    CGRect frame = self.frame;
    frame.origin.y = originY;
    self.frame = frame;
}

- (void)resetOriginYByOffset:(CGFloat)offset {
    CGRect frame = self.frame;
    frame.origin.y += offset;
    self.frame = frame;
}

- (void)resetOriginXByOffset:(CGFloat)offset {
    CGRect frame = self.frame;
    frame.origin.x += offset;
    self.frame = frame;
}

- (void)resetOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

#pragma mark Reset Center
- (void)resetCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (void)resetCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (void)resetCenter:(CGPoint)center {
    self.center = center;
}

#pragma mark -
#pragma mark Reset Size
- (void)resetWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)resetHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)resetWidthByOffset:(CGFloat)offset {
    CGRect frame = self.frame;
    frame.size.width += offset;
    self.frame = frame;
}

- (void)resetHeightByOffset:(CGFloat)offset {
    CGRect frame = self.frame;
    frame.size.height += offset;
    self.frame = frame;
}

- (void)resetSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

@end

@implementation UIView (Getter)

#pragma mark -
#pragma mark Get Origin
- (CGFloat)getOriginX {
    return [self getOrigin].x;
}

- (CGFloat)getOriginY {
    return [self getOrigin].y;
}

- (CGPoint)getOrigin {
    return self.frame.origin;
}

#pragma mark Get Center
- (CGFloat)getCenterY {
    return [self getCenter].y;
}

- (CGFloat)getCenterX {
    return [self getCenter].x;
}

- (CGPoint)getCenter {
    return self.center;
}

#pragma mark -
#pragma mark Reset Size
- (CGFloat)getWidth {
    return [self getSize].width;
}
- (CGFloat)getHeight {
    return [self getSize].height;
}
- (CGSize)getSize {
    return self.frame.size;
}

@end
