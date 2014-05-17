//
//  HTViewController.m
//  Hangman Game
//
//  Created by Tom Hu on 5/17/14.
//  Copyright (c) 2014 Tom Hu. All rights reserved.
//

#import "HTInitViewController.h"
#import "HTMainViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <Shimmer/FBShimmeringView.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface HTInitViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *initiateGameButton;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *secret;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UIAlertView *alertView;

@property (weak, nonatomic) IBOutlet UIView *headerView;

@end

@implementation HTInitViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // UI Methods
    [self configureHeaderView];
    [self configureInitiateGameButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"转换");
    
    if ([segue.destinationViewController respondsToSelector:@selector(setSecret:)] && [segue.destinationViewController respondsToSelector:@selector(setUserId:)]) {
        [segue.destinationViewController performSelector:@selector(setSecret:) withObject:self.secret];
        
        [segue.destinationViewController performSelector:@selector(setUserId:) withObject:self.userId];
    }
}

#pragma mark - UI Methods

- (void)configureHeaderView {
    FBShimmeringView *shimmeringView = [[FBShimmeringView alloc] initWithFrame:self.headerView.bounds];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:shimmeringView.bounds];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.text = @"Initiate Game!";
    headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:32.0f];
    headerLabel.textColor = UIColorFromRGB(0x769E48);
    headerLabel.backgroundColor = [UIColor clearColor];
    
    shimmeringView.contentView = headerLabel;
    
    // Start shimmering.
    shimmeringView.shimmering = YES;
    shimmeringView.shimmeringOpacity = 0.65;
    shimmeringView.shimmeringPauseDuration = 0.3;
    
    [self.headerView addSubview:shimmeringView];
}

- (void)configureInitiateGameButton {
    // Set hightlighted image
    [self.initiateGameButton setImage:[UIImage imageNamed:@"HTInitiateGameButtonHl"] forState:UIControlStateHighlighted];
}

#pragma mark - Actions

- (IBAction)initGame:(UIButton *)sender {
    self.userId = self.emailTextField.text;
    
    NSMutableDictionary *postDataDictionary = [[NSMutableDictionary alloc] init];
    
    [postDataDictionary setValue:@"initiateGame" forKey:@"action"];
    [postDataDictionary setValue:self.userId forKey:@"userId"];
    
    NSString *gameURL = @"http://strikingly-interview-test.herokuapp.com/guess/process";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    // Start animation
    [self.activityIndicator startAnimating];
    
    // POST
    [manager POST:gameURL parameters:postDataDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Stop animation
        [self.activityIndicator stopAnimating];
        
        // Success
        NSLog(@"JSON: %@", responseObject);
        
        self.userId = [(NSDictionary *)responseObject objectForKey:@"userId"];
        self.secret =[(NSDictionary *)responseObject objectForKey:@"secret"];
        
        [self performSegueWithIdentifier:@"StartGame" sender:sender];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Stop animation
        [self.activityIndicator stopAnimating];
        
        self.alertView = [[UIAlertView alloc] initWithTitle:@"Oops~" message:@"Network error. Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [self.alertView show];
        
        // Error
        NSLog(@"Error: %@", error);
    }];
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // 触发点击事件
    [self.initiateGameButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Keyboard

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    // Hide Keyboard
    [self.emailTextField resignFirstResponder];
}

@end
