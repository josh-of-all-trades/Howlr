#import "ParseStarterProjectViewController.h"
#import <Parse/Parse.h>
#import "SignUpViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface ParseStarterProjectViewController ()
{
    IBOutlet UITextField *emailField;
    IBOutlet UITextField *passwordField;
}

//IBActions
- (IBAction)logInButtonHit:(id)sender;
- (IBAction)signUpButtonHit:(id)sender;
-(IBAction)facebookButtonHit:(id)sender;

@end

@implementation ParseStarterProjectViewController


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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
                                                                  otherButtonTitles:nil, nil];
                                            [alert show];
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

- (IBAction)signUpButtonHit:(id)sender{
    SignUpViewController *sucv = [[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil];
    [self presentViewController:sucv animated:YES completion:nil];
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
                [alert show];            }
        } else if (user.isNew) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Success"
                                  message:@"You signed up and logged in through facebook!"
                                  delegate:self
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil, nil];
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Success"
                                  message:@"You logged in through facebook!"
                                  delegate:self
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil, nil];
            [alert show];        }
    }];
}

#pragma mark - UIViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
