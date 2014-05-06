//
//  JERSignUpViewController.m
//  Howlr
//
//  Created by Josh Rojas on 4/16/14.
//  Copyright (c) 2014 Joshua Rojas. All rights reserved.
//

#import "JERSignUpViewController.h"
#import <Parse/Parse.h>
#import "JERProfileShowViewController.h"

@interface JERSignUpViewController () <UIActionSheetDelegate, UITextFieldDelegate>
{
    IBOutlet UITextField *emailField;
    IBOutlet UITextField *passwordField;
    IBOutlet UITextField *passwordConfirmField;
    IBOutlet UITextField *nameField;
    IBOutlet UITextField *phoneNumberField;
    
}

//IBActions
- (IBAction)backButtonHit:(id)sender;
- (IBAction)signUpButtonHit:(id)sender;

//cool keyboard stuff
@property (nonatomic, strong) UIToolbar *keyboardToolbar;
@property (nonatomic, strong) UIBarButtonItem *previousButton;
@property (nonatomic, strong) UIBarButtonItem *nextButton;
- (void) nextField;
- (void) previousField;
- (void) resignKeyboard;



@end

@implementation JERSignUpViewController

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
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    emailField.inputAccessoryView = self.keyboardToolbar;
    passwordField.inputAccessoryView = self.keyboardToolbar;
    passwordConfirmField.inputAccessoryView = self.keyboardToolbar;
    nameField.inputAccessoryView = self.keyboardToolbar;
    phoneNumberField.inputAccessoryView = self.keyboardToolbar;

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonHit:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Never Mind"
                                               destructiveButtonTitle:@"Cancel"
                                                    otherButtonTitles:nil, nil];
    [actionSheet showInView:self.view];
}

- (IBAction)signUpButtonHit:(id)sender{
    NSString *email = emailField.text;
    NSString *password1 = passwordField.text;
    NSString *password2 = passwordConfirmField.text;
    
    if ([password1 isEqualToString:password2]) {
        PFUser *user = [PFUser user];
        user.username = email;
        user.email = email;
        user.password = password1;
        user[@"name"] = nameField.text;
        user[@"phoneNumber"] = phoneNumberField.text;
        user[@"likes"] = [[NSArray alloc] init];
        user[@"blockList"] = [[NSArray alloc] init];


        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
                    user[@"location"] = geoPoint;
                    [user save];
                }];
                // Hooray! Let them use the app now.
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Sign up"
                                      message:@"Hurray you signed up!"
                                      delegate:self
                                      cancelButtonTitle:@"Ok"
                                      otherButtonTitles:nil, nil];
                [alert show];
                [self performSegueWithIdentifier:@"LoggedIn" sender:self];
            } else {
                // Show the errorString somewhere and let the user try again.
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
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}


#pragma mark - Keyboard Toolbar

- (void) nextField
{
    if ([emailField isFirstResponder]) {
        [passwordField becomeFirstResponder];
    } else if ([passwordField isFirstResponder]){
        [passwordConfirmField becomeFirstResponder];
    } else if ([passwordConfirmField isFirstResponder]){
        [nameField becomeFirstResponder];
    } else if([nameField isFirstResponder]){
        [phoneNumberField becomeFirstResponder];
    }
    
}

- (void) previousField
{
    //if text field is email
    //make name field be the one with the cursor
    if([phoneNumberField isFirstResponder]){
        [nameField becomeFirstResponder];
    } else if ([nameField isFirstResponder]){
        [passwordConfirmField becomeFirstResponder];
    } else if ([passwordConfirmField isFirstResponder]){
        [passwordField becomeFirstResponder];
    } else if ([passwordField isFirstResponder]) {
        [emailField becomeFirstResponder];
    }
}

- (void) resignKeyboard
{
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
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
    
    if (textField == phoneNumberField) {
        self.nextButton.enabled = NO;
    } else {
        self.nextButton.enabled = YES;
    }
    
    if (textField == passwordField) {
        viewFrame.origin.y = -40;
    } else if (textField == passwordConfirmField) {
        viewFrame.origin.y = -80;
    } else if (textField == nameField){
        viewFrame.origin.y = -120;
    } else if (textField == phoneNumberField){
        viewFrame.origin.y = - 140;
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





- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    
    UIAlertView *privaceErrorMessage = [[UIAlertView alloc] initWithTitle:@"No Access"
                                                                  message:@"Sorry but our app does not have access to your location.  Please change this in Settings->Privacy->Location"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
    
    [privaceErrorMessage show];
    
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
