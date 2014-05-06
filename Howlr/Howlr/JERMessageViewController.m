//
//  JERMessageViewController.m
//  Howlr
//
//  Created by Josh Rojas on 5/6/14.
//  Copyright (c) 2014 Joshua Rojas. All rights reserved.
//

#import "JERMessageViewController.h"

@interface JERMessageViewController () <UIActionSheetDelegate>


@property (nonatomic, strong) IBOutlet UILabel *senderName;
@property (nonatomic, strong) IBOutlet UITextField *messageTitle;
@property (nonatomic, strong) IBOutlet UITextView *messageBody;

//cool keyboard stuff
@property (nonatomic, strong) UIToolbar *keyboardToolbar;
@property (nonatomic, strong) UIBarButtonItem *previousButton;
@property (nonatomic, strong) UIBarButtonItem *nextButton;
- (void) nextField;
- (void) previousField;
- (void) resignKeyboard;
@end

@implementation JERMessageViewController

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
    self.messageTitle.inputAccessoryView = self.keyboardToolbar;
    self.messageBody.inputAccessoryView = self.keyboardToolbar;
    self.senderName.text = [[PFUser currentUser] valueForKey:@"name"];
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

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}



- (IBAction)sendButtonHit:(id)sender{
    PFObject *message = [PFObject objectWithClassName:@"Message"];
    message[@"receiverId"] = self.cellUser.objectId;
    message[@"senderName"] = [[PFUser currentUser] valueForKey:@"name"];
    message[@"messageTitle"] = self.messageTitle.text;
    message[@"messageBody"] = self.messageBody.text;
    [message saveEventually];
}


- (void) nextField
{
    if ([self.messageTitle isFirstResponder]) {
        [self.messageBody becomeFirstResponder];
    }
}

- (void) previousField
{
    //if text field is email
    //make name field be the one with the cursor
    if([self.messageBody isFirstResponder]){
        [self.messageTitle becomeFirstResponder];
    }
}

- (void) resignKeyboard
{
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UITextView class]]) {
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
