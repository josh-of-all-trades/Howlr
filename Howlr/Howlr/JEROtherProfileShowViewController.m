//
//  JEROtherProfileShowViewController.m
//  Howlr
//
//  Created by Josh Rojas on 4/27/14.
//  Copyright (c) 2014 Joshua Rojas. All rights reserved.
//

#import "JEROtherProfileShowViewController.h"
#import <Parse/Parse.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "JERMessageViewController.h"

@interface JEROtherProfileShowViewController () <MFMailComposeViewControllerDelegate>


@property (strong, nonatomic) IBOutlet UILabel *nameField;
@property (strong, nonatomic) IBOutlet UILabel *emailField;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumberField;
@property (strong, nonatomic) IBOutlet PFImageView *photoField;
@end

@implementation JEROtherProfileShowViewController

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
    PFUser *currentUser = self.cellUser;
    [self.nameField setText:[currentUser valueForKey:@"name"]];
    [self.emailField setText:currentUser.email];
    [self.phoneNumberField setText:[currentUser valueForKey:@"phoneNumber"]];
    PFFile *photoFile = [currentUser valueForKey:@"photo1"];
    self.photoField.file = photoFile;
    [self.photoField loadInBackground];
    
    UITapGestureRecognizer *phoneRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhoneNumber:)];
    [self.phoneNumberField setUserInteractionEnabled:YES];
    [self.phoneNumberField addGestureRecognizer:phoneRec];
    
    
    
    UITapGestureRecognizer* mail1LblGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mail1LblTapped:)];
    // if labelView is not set userInteractionEnabled, you must do so
    [self.emailField setUserInteractionEnabled:YES];
    [self.emailField addGestureRecognizer:mail1LblGesture];
}

- (void)viewDidAppear:(BOOL)animated{
    PFUser *currentUser = self.cellUser;
    [self.nameField setText:[currentUser valueForKey:@"name"]];
    [self.emailField setText:currentUser.email];
    [self.phoneNumberField setText:[currentUser valueForKey:@"phoneNumber"]];
    PFFile *photoFile = [currentUser valueForKey:@"photo1"];
    self.photoField.file = photoFile;
    [self.photoField loadInBackground];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonHit:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)likeButtonHit:(id)sender{
    NSMutableArray *likes = [self.cellUser valueForKey:@"likes"];
    if ([likes containsObject:[[PFUser currentUser] objectId]]){
        //do nothing
    } else {
        [likes addObject:[[PFUser currentUser] objectId]];
    }
   
    NSMutableDictionary *cloudDic = [[NSMutableDictionary alloc] init];
    [cloudDic setValue:[self.cellUser objectId] forKey:@"likedUser"];
    [cloudDic setValue:likes forKey:@"newLikesArray"];
    
    [PFCloud callFunction:@"updateLikes" withParameters:cloudDic];
//    [PFCloud callFunctionInBackground:@"updateLikes" withParameters:cloudDic block:^(id object, NSError *error) {
//        if(!error){
    
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Profile Liked"
                                                            message:@"You have liked this user's profile"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
//        }
//    }];

}

- (IBAction)blockButtonHit:(id)sender{
    NSMutableArray *blocks = [self.cellUser valueForKey:@"blockList"];
    if ([blocks containsObject:[[PFUser currentUser] objectId]]){
        //do nothing
    } else {
        [blocks addObject:[[PFUser currentUser] objectId]];
    }
    
    NSMutableDictionary *cloudDic = [[NSMutableDictionary alloc] init];
    [cloudDic setValue:[self.cellUser objectId] forKey:@"blockedUser"];
    [cloudDic setValue:blocks forKey:@"newBlocksArray"];
    
    [PFCloud callFunction:@"block" withParameters:cloudDic];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Profile blocked"
                                                    message:@"You have liked this user's profile"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)callPhoneNumber:(id)sender {
    NSString *phoneNumber = [@"tel://" stringByAppendingString:self.phoneNumberField.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

- (IBAction)composeMessageHit:(id)sender{
    JERMessageViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"messageView"];
    vc.cellUser = self.cellUser;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)mail1LblTapped:(id)sender
{
    if ([MFMailComposeViewController canSendMail])
    {
        
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@""];
        NSArray *toRecipients = [NSArray arrayWithObjects:self.emailField.text, nil];
        [mailer setToRecipients:toRecipients];
        NSString *emailBody = @"";
        [mailer setMessageBody:emailBody isHTML:NO];
        mailer.navigationBar.barStyle = UIBarStyleBlackOpaque;
        [self presentModalViewController:mailer animated:YES];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    // Remove the mail view
    [self dismissModalViewControllerAnimated:YES];
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
