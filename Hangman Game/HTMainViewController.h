//
//  HTMainViewController.h
//  Hangman Game
//
//  Created by Tom Hu on 5/17/14.
//  Copyright (c) 2014 Tom Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTMainViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *secret;

@end
