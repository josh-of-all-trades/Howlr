//
//  JERProfileShowViewController.m
//  Howlr
//
//  Created by Josh Rojas on 4/22/14.
//  Copyright (c) 2014 Joshua Rojas. All rights reserved.
//

#import "JERProfileShowViewController.h"
#import <Parse/Parse.h>

@interface JERProfileShowViewController () {

    IBOutlet UILabel *nameField;
    IBOutlet UILabel *emailField;
    IBOutlet UILabel *phoneNumberField;
    IBOutlet PFImageView *photo1Field;
    //IBOutlet PFImageView *photo2Field;
    //IBOutlet PFImageView *photo3Field;
}

@end

@implementation JERProfileShowViewController

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
    PFUser *currentUser = [PFUser currentUser];
    [nameField setText:[currentUser valueForKey:@"name"]];
    [emailField setText:currentUser.email];
    [phoneNumberField setText:[currentUser valueForKey:@"phoneNumber"]];
    PFFile *photo1File = [currentUser valueForKey:@"photo1"];
    photo1Field.file = photo1File;
    [photo1Field loadInBackground];
}

- (void)viewDidAppear:(BOOL)animated{
     PFUser *currentUser = [PFUser currentUser];
    [nameField setText:[currentUser valueForKey:@"name"]];
    [emailField setText:currentUser.email];
    [phoneNumberField setText:[currentUser valueForKey:@"phoneNumber"]];
    PFFile *photo1File = [currentUser valueForKey:@"photo1"];
    photo1Field.file = photo1File;
    [photo1Field loadInBackground];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
