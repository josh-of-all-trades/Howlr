//
//  SignUpViewController.m
//  ParseStarterProject
//
//  Created by Josh Rojas on 4/16/14.
//
//
#import <Parse/Parse.h>
#import "SignUpViewController.h"
#import "ParseStarterProjectViewController.h"

@interface SignUpViewController ()
{
    IBOutlet UITextField *emailField;
    IBOutlet UITextField *passwordField;
    IBOutlet UITextField *passwordConfirmField;
    IBOutlet UITextField *nameField;
}

//IBActions
- (IBAction)backButtonHit:(id)sender;
- (IBAction)signUpButtonHit:(id)sender;


@end

@implementation SignUpViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonHit:(id)sender{
    ParseStarterProjectViewController *pspcv = [[ParseStarterProjectViewController alloc] initWithNibName:@"ParseStarterProjectViewController" bundle:nil];
    
    [self presentViewController:pspcv animated:YES completion:nil];
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
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                // Hooray! Let them use the app now.
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Sign up"
                                      message:@"Hurray you signed up!"
                                      delegate:self
                                      cancelButtonTitle:@"Cancel"
                                      otherButtonTitles:nil, nil];
                [alert show];
            } else {
                NSString *errorString = [error userInfo][@"error"];
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

@end
