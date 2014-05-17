//
//  UIView+Animation.h
//  Hangman Game
//
//  Created by Tom Hu on 5/17/14.
//  Copyright (c) 2014 Tom Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Animation)

- (void)fadeIn;
- (void)fadeInWithCompletion:(void (^)(void))completion;
- (void)fadeOut;
- (void)fadeOutWithCompletion:(void (^)(void))completion;

@end
