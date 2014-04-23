//
//  JERLogInViewController.m
//  Howlr
//
//  Created by Josh Rojas on 4/16/14.
//  Copyright (c) 2014 Joshua Rojas. All rights reserved.
//

#import "JERLogInViewController.h"
#import <Parse/Parse.h>
#import "JERProfileShowViewController.h"

@interface JERLogInViewController () <UITextFieldDelegate>
{
    IBOutlet UITextField *emailField;
    IBOutlet UITextField *passwordField;
}

//IBActions
- (IBAction)logInButtonHit:(id)sender;
//- (IBAction)signUpButtonHit:(id)sender;
-(IBAction)facebookButtonHit:(id)sender;

//cool keyboard stuff
@property (nonatomic, strong) UIToolbar *keyboardToolbar;
@property (nonatomic, strong) UIBarButtonItem *previousButton;
@property (nonatomic, strong) UIBarButtonItem *nextButton;
- (void) nextField;
- (void) previousField;
- (void) resignKeyboard;

@property (nonatomic, strong) PFUser *currentUser;


@end

@implementation JERLogInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    emailField.inputAccessoryView = self.keyboardToolbar;
    passwordField.inputAccessoryView = self.keyboardToolbar;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentUser = [PFUser currentUser];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logInButtonHit:(id)sender{
    NSString *email = emailField.text;
    NSString *password = passwordField.text;
    
    [PFUser logInWithUsernameInBackground:email password:password
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                            UIAlertView *alert = [[UIAlertView alloc]
                                                                  initWithTitle:@"Success"
                                                                  message:@"You logged in!"
                                                                  delegate:self
                                                                  cancelButtonTitle:@"Cancel"
                                                                  otherButtonTitles:@"Ok", nil];
                                            [alert show];
                                            self.currentUser = [PFUser currentUser];
                                            [self performSegueWithIdentifier:@"LoggedIn" sender:self];
                                        } else {
                                            // The login failed. Check error to see why.
                                            UIAlertView *alert = [[UIAlertView alloc]
                                                                  initWithTitle:@"Error"
                                                                  message:error.description
                                                                  delegate:self
                                                                  cancelButtonTitle:@"OK"
                                                                  otherButtonTitles:nil, nil];
                                            [alert show];
                                        }
                                    }];
}



-(IBAction)facebookButtonHit:(id)sender{
    NSArray *permissions = @[@"user_about_me"];
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
        if (!user) {
            if (!error){
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Error"
                                      message:@"Uh oh. The user cancelled the Facebook login."
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil, nil];
                [alert show];
            } else {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Error"
                                      message:error.description
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil, nil];
                [alert show];
            }
        } else if (user.isNew) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Success"
                                  message:@"You signed up and logged in through facebook!"
                                  delegate:self
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil, nil];
            [alert show];
            self.currentUser = [PFUser currentUser];

            [self performSegueWithIdentifier:@"LoggedIn" sender:self];

        } else {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Success"
                                  message:@"You logged in through facebook!"
                                  delegate:self
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil, nil];
            [alert show];
            self.currentUser = [PFUser currentUser];

            [self performSegueWithIdentifier:@"LoggedIn" sender:self];
        }
    }];
}


#pragma mark - Keyboard Toolbar

- (void) nextField
{
    if ([emailField isFirstResponder]) {
        [passwordField becomeFirstResponder];
    }

}

- (void) previousField
{
    //if text field is email
    //make name field be the one with the cursor
    if ([passwordField isFirstResponder]) {
        [emailField becomeFirstResponder];
    }
}

- (void) resignKeyboard
{
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            [view resignFirstResponder];
        }
        if ([view isKindOfClass:[UITextView class]]) {
            [view resignFirstResponder];
        }
    }
}


- (UIToolbar *)keyboardToolbar
{
    if (!_keyboardToolbar) {
        _keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        self.previousButton = [[UIBarButtonItem alloc] initWithTitle:@"Previous"
                                                               style:UIBarButtonItemStyleBordered
                                                              target:self
                                                              action:@selector(previousField)];
        
        self.nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next"
                                                           style:UIBarButtonItemStyleBordered
                                                          target:self
                                                          action:@selector(nextField)];
        
        UIBarButtonItem *extraSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                    target:self
                                                                                    action:nil];
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(resignKeyboard)];
        
        [_keyboardToolbar setItems:@[self.previousButton, self.nextButton, extraSpace, doneButton]];
    }
    
    return _keyboardToolbar;
}

#pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    
    if (textField == emailField) {
        self.previousButton.enabled = NO;
    } else {
        self.previousButton.enabled = YES;
    }
    
    if (textField == passwordField) {
        self.nextButton.enabled = NO;
    } else {
        self.nextButton.enabled = YES;
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    
    self.view.frame = viewFrame;
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y = 0;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    
    [textField resignFirstResponder];
    self.view.frame = viewFrame;
    
    [UIView commitAnimations];
}


//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([segue.identifier isEqualToString:@"LoggedIn"]) {
//
//        UINavigationController *navigationController = segue.destinationViewController;
//        JERProfileShowViewController *profileShow = [navigationController viewControllers][0];
//        //profileShow.delegate = self;
//    }
//}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if (self.currentUser == nil && [identifier isEqualToString:@"LoggedIn"]){
        return NO;
    }
    return YES;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
