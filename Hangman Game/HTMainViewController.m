//
//  HTMainViewController.m
//  Hangman Game
//
//  Created by Tom Hu on 5/17/14.
//  Copyright (c) 2014 Tom Hu. All rights reserved.
//

#import "HTMainViewController.h"
#import "UIView+Resize.h"
#import <AFNetworking/AFNetworking.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface HTMainViewController ()

@property (weak, nonatomic) IBOutlet UIButton *makeGuessButton; // Make a guess
@property (weak, nonatomic) IBOutlet UIButton *getWordButton; // Get a new word or skip current word
@property (weak, nonatomic) IBOutlet UIButton *submitResultsButton; // Submit test results
@property (weak, nonatomic) IBOutlet UILabel *wordLabel; // Display word
@property (weak, nonatomic) IBOutlet UILabel *numberOfWordsTriedLabel; // Number of words tried
@property (weak, nonatomic) IBOutlet UILabel *numberOfGuessTriedForThisWordLabel; // Number of guess tried for current word
@property (weak, nonatomic) IBOutlet UILabel *totalScoreLabel; // Total score
@property (weak, nonatomic) IBOutlet UITextField *guessLetterTextField; // Input text field for guessing letter
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UIAlertView *alertView;

@property int numberOfCorrectWord;
@property int numberOfWrongGuess;

@property int totalScore;

@end

@implementation HTMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Add observer for keyboard
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    // UI Methods
    [self configureNavigationBar];
    [self configureStatisticDataLabel];
    [self configureButtonStatus];
    [self configureMakeGuessButton];
    [self configureGetWordButton];
    [self configureActivityIndicator];
    [self configureAlertView];
    
    // init
    self.numberOfCorrectWord = 0;
    self.numberOfWrongGuess = 0;
    
    self.totalScore = 0;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Show navigation bar
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

#pragma mark - UI Methods

- (void)configureNavigationBar {
    // Change navigation bar background color
    [[[self navigationController] navigationBar] setBarTintColor:UIColorFromRGB(0x769E48)];
    [[[self navigationController] navigationBar] setTranslucent:YES];
    
    // Change navigation button color
    [[[self navigationController] navigationBar] setTintColor:[UIColor whiteColor]];
    
    // Change navigation bar title style
    [[[self navigationController] navigationBar] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                         [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                         [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
}

- (void)configureStatisticDataLabel {
    // Clear all the statis
    self.totalScoreLabel.text = @"0";
    self.numberOfWordsTriedLabel.text = @"0";
    self.numberOfGuessTriedForThisWordLabel.text = @"0";
}

- (void)configureButtonStatus {
    // Disable guess Button at first
    self.makeGuessButton.enabled = NO;
    
    // Disable submit button
    self.submitResultsButton.enabled = NO;
}

- (void)configureMakeGuessButton {
    // Set highlighted image
    [self.makeGuessButton setImage:[UIImage imageNamed:@"HTMakeGuessButtonHl"] forState:UIControlStateHighlighted];
    
    // Set disabled image
    [self.makeGuessButton setImage:[UIImage imageNamed:@"HTMakeGuessButtonDisabled"] forState:UIControlStateDisabled];
}

- (void)configureGetWordButton {
    // Set highlighted image
    [self.getWordButton setImage:[UIImage imageNamed:@"HTGetWordButtonHl"] forState:UIControlStateHighlighted];
    
    // Set disabled image
    [self.getWordButton setImage:[UIImage imageNamed:@"HTGetWordButtonDisabled"] forState:UIControlStateDisabled];
}

- (void)configureActivityIndicator {
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 20.0f)];
    [self.activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [self.activityIndicator setHidesWhenStopped:YES];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
}

- (void)configureAlertView {
    
}

- (void)changeGetWordButtonToSkipWordButton {
    // Set normal image
    [self.getWordButton setImage:[UIImage imageNamed:@"HTSkipWordButton"] forState:UIControlStateNormal];
    
    // Set highlighted image
    [self.getWordButton setImage:[UIImage imageNamed:@"HTSkipWordButtonHl"] forState:UIControlStateHighlighted];
    
    // Set disabled image
    [self.getWordButton setImage:[UIImage imageNamed:@"HTSkipWordButtonDisabled"] forState:UIControlStateDisabled];
}

- (void)changeSkipWordButtonToGetWordButton {
    // Set normal image
    [self.getWordButton setImage:[UIImage imageNamed:@"HTGetWordButton"] forState:UIControlStateNormal];
    
    // Set highlighted image
    [self.getWordButton setImage:[UIImage imageNamed:@"HTGetWordButtonHl"] forState:UIControlStateHighlighted];
    
    // Set disabled image
    [self.getWordButton setImage:[UIImage imageNamed:@"HTGetWordButtonDisabled"] forState:UIControlStateDisabled];
}

#pragma mark - Actions

- (IBAction)getWord:(UIButton *)sender {
    // init post data dictionary
    NSDictionary *postDataDictionary = @{
                                         @"userId": self.userId,
                                         @"secret": self.secret,
                                         @"action": @"nextWord"
                                         };
    
    NSString *gameURL = @"http://strikingly-interview-test.herokuapp.com/guess/process";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    // Start animation
    [self.activityIndicator startAnimating];
    
    // POST
    [manager POST:gameURL parameters:postDataDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Stop animation
        [self.activityIndicator stopAnimating];
        
        // Get word success
        NSLog(@"JSON: %@", responseObject);
        
        // Get result dictionary
        NSDictionary *result = (NSDictionary *)responseObject;
        
        // 80 words
        if ([[[result objectForKey:@"data"] objectForKey:@"numberOfWordsTried"] intValue] == 80) {
            // Enable submit button
            self.submitResultsButton.enabled = YES;
        }
        
        // Get word button -> Skip word button
        [self changeGetWordButtonToSkipWordButton];
        
        // Update word label text
        self.wordLabel.text = [result objectForKey:@"word"];
        
        // Update statistical data
        self.numberOfWordsTriedLabel.text = [[[result objectForKey:@"data"] objectForKey:@"numberOfWordsTried"] stringValue];
        self.numberOfGuessTriedForThisWordLabel.text = [NSString stringWithFormat:@"%d", 10 - [[[result objectForKey:@"data"] objectForKey:@"numberOfGuessAllowedForThisWord"] intValue]];
        
        // Endble guess button and guess letter text field
        self.makeGuessButton.enabled = YES;
        self.guessLetterTextField.enabled = YES;
        
        // Make guess letter text field first respond
        [self.guessLetterTextField becomeFirstResponder];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Stop animation
        [self.activityIndicator stopAnimating];
        
        // Error
        NSLog(@"Error: %@", error);
    }];
}

- (IBAction)makeGuess:(UIButton *)sender {
    // Disable guess button
    [sender setEnabled:NO];
    
    // init post data dictionary
    NSDictionary *postDataDictionary = @{
                                         @"userId": self.userId,
                                         @"secret": self.secret,
                                         @"action": @"guessWord",
                                          @"guess": self.guessLetterTextField.text
                                         };
    
    NSString *gameURL = @"http://strikingly-interview-test.herokuapp.com/guess/process";
    
    // Prepare for http request
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    // Start animation
    [self.activityIndicator startAnimating];
    
    // POST
    [manager POST:gameURL parameters:postDataDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Stop animation
        [self.activityIndicator stopAnimating];
        
        // Make guess uccess
        NSLog(@"JSON: %@", responseObject);
        
        // Get result dictionary
        NSDictionary *result = (NSDictionary *)responseObject;
        
        // 80 words
        if ([[[result objectForKey:@"data"] objectForKey:@"numberOfWordsTried"] intValue] == 80) {
            // Enable submit button
            self.getWordButton.enabled = NO;
        }
        
        // Wrong guess or not
        if ([[result objectForKey:@"word"] isEqualToString:self.wordLabel.text]) {
            // Wrong guess
            self.numberOfWrongGuess++;
        }
        
        // Update word label text
        self.wordLabel.text = [result objectForKey:@"word"];
        
        // Update statistical data
        self.numberOfGuessTriedForThisWordLabel.text = [NSString stringWithFormat:@"%d", 10 - [[[result objectForKey:@"data"] objectForKey:@"numberOfGuessAllowedForThisWord"] intValue]];
        
        if ([[[result objectForKey:@"data"] objectForKey:@"numberOfGuessAllowedForThisWord"] intValue] == 0) {
            // No chance for guessing
            // Skip word button -> Get word button
            [self changeSkipWordButtonToGetWordButton];
            
            // Disable guess button
            sender.enabled = NO;
            
            // Clear and disable guess letter text field
            self.guessLetterTextField.text = @"";
            self.guessLetterTextField.enabled = NO;
        } else {
            // Still have chance for guessing
            // Enable guess button
            [sender setEnabled:YES];
        }
        
        // Correct word or not
        BOOL correct = YES; // Default is correct
        for (int i = 0; i < [self.wordLabel.text length]; i++) {
            if ([self.wordLabel.text characterAtIndex:i] == '*') {
                // Not correct
                correct = NO;
                break;
            }
        }
        if (correct) {
            self.numberOfCorrectWord++;
            
            // Disable guess button
            sender.enabled = NO;
            
            // Skip word button -> Get word button
            [self changeSkipWordButtonToGetWordButton];
        }
        
        // Update total score label
        [self updateTotalScoreLabel];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Stop animation
        [self.activityIndicator stopAnimating];
        
        // Error
        NSLog(@"Error: %@", error);
    }];
}

- (IBAction)submitResults:(UIButton *)sender {
    // Start animation
    [self.activityIndicator startAnimating];
    
    // Disable submit button, get word button, make guess button
    sender.enabled = NO;
    self.getWordButton.enabled = NO;
    self.makeGuessButton = NO;
    
    // init post data dictionary
    NSDictionary *postDataDictionary = @{
                                         @"userId": self.userId,
                                         @"secret": self.secret,
                                         @"action": @"getTestResults",
                                         };
    
    NSString *gameURL = @"http://strikingly-interview-test.herokuapp.com/guess/process";
    
    // Prepare for http request
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    // POST
    [manager POST:gameURL parameters:postDataDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Stop animation
        [self.activityIndicator stopAnimating];
        
        // Get test results uccess
        NSLog(@"JSON: %@", responseObject);
        
        [self submitTestResults];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Stop animation
        [self.activityIndicator stopAnimating];
        
        // Error
        NSLog(@"Error: %@", error);
    }];
}

- (void)submitTestResults {
    // init post data dictionary
    NSDictionary *postDataDictionary = @{
                                         @"userId": self.userId,
                                         @"secret": self.secret,
                                         @"action": @"submitTestResults",
                                         };
    
    NSString *gameURL = @"http://strikingly-interview-test.herokuapp.com/guess/process";
    
    // Prepare for http request
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    // Start animation
    [self.activityIndicator startAnimating];
    
    // POST
    [manager POST:gameURL parameters:postDataDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Stop animation
        [self.activityIndicator stopAnimating];
        
        // Get test results uccess
        NSLog(@"JSON: %@", responseObject);
        
        // Get result dictionary
        NSDictionary *result = (NSDictionary *)responseObject;
        
        self.alertView = [[UIAlertView alloc] initWithTitle:@"Successfully submit!" message:[NSString stringWithFormat:@"Your total score: %@", [[[result objectForKey:@"data"] objectForKey:@"totalScore"] stringValue]] delegate:self cancelButtonTitle:@"OK! I know!" otherButtonTitles:nil];
        [self.alertView show];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Stop animation
        [self.activityIndicator stopAnimating];
        
        // Error
        NSLog(@"Error: %@", error);
    }];
}

- (int)getTotalScore {
    return 20 * self.numberOfCorrectWord - self.numberOfWrongGuess;
}

- (void)updateTotalScoreLabel {
    // Update total score label
    self.totalScoreLabel.text = [NSString stringWithFormat:@"%d", [self getTotalScore]];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Display one character at most
    textField.text = string;
    
    // Avoid changes to the text field
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // 触发事件
    [self.makeGuessButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    return YES;
}

#pragma mark - Keyboard

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    // Hide Keyboard
    [self.guessLetterTextField resignFirstResponder];
}

- (void)keyboardDidShow:(NSNotification *)notification {
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
}

@end
