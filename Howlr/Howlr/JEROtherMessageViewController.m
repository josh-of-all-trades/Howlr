//
//  JEROtherMessageViewController.m
//  Howlr
//
//  Created by Josh Rojas on 5/6/14.
//  Copyright (c) 2014 Joshua Rojas. All rights reserved.
//

#import "JEROtherMessageViewController.h"

@interface JEROtherMessageViewController () <UIActionSheetDelegate>

@property (nonatomic, strong) IBOutlet UILabel *senderName;
@property (nonatomic, strong) IBOutlet UILabel *messageTitle;
@property (nonatomic, strong) IBOutlet UITextView *messageBody;
@end

@implementation JEROtherMessageViewController

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
    self.senderName.text = [self.message valueForKey:@"senderName"];
    self.messageTitle.text = [self.message valueForKey:@"messageTitle"];
    self.messageBody.text = [self.message valueForKey:@"messageBody"];
}

-(void) viewDidAppear:(BOOL)animated{
    self.senderName.text = [self.message valueForKey:@"senderName"];
    self.messageTitle.text = [self.message valueForKey:@"messageTitle"];
    self.messageBody.text = [self.message valueForKey:@"messageBody"];
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
