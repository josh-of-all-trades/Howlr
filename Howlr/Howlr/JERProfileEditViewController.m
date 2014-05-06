//
//  JERProfileEditViewController.m
//  Howlr
//
//  Created by Josh Rojas on 4/22/14.
//  Copyright (c) 2014 Joshua Rojas. All rights reserved.
//

#import "JERProfileEditViewController.h"
#import <Parse/Parse.h>

@interface JERProfileEditViewController ()<UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>
{
    
    IBOutlet UITextField *nameField;
    IBOutlet UITextField *emailField;
    IBOutlet UITextField *phoneNumberField;
    IBOutlet PFImageView *photo1Field;
    //IBOutlet PFImageView *photo2Field;
    //IBOutlet PFImageView *photo3Field;
}


- (IBAction)backButtonHit:(id)sender;
- (IBAction)doneButtonHit:(id)sender;

- (IBAction)choosePhoto:(id)sender;
- (void)takePicture;
- (void)choosePicture;



@end

@implementation JERProfileEditViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonHit:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButtonHit:(id)sender{
    PFUser *currentUser = [PFUser currentUser];
    [currentUser setObject:nameField.text forKey:@"name"];
    [currentUser setEmail:emailField.text];
    [currentUser setUsername:emailField.text];
    [currentUser setObject:phoneNumberField.text forKey:@"phoneNumber"];
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        [currentUser setObject:geoPoint forKey:@"location"];
        [currentUser saveEventually];
    }];
    
    NSData * photo1data = UIImageJPEGRepresentation(photo1Field.image, 0.05f);
    PFFile *photo1File = [PFFile fileWithName:@"photo1.jpg" data:photo1data];
    
    [photo1File save];
    
    [currentUser setObject:photo1File forKey:@"photo1"];
    
    [currentUser saveEventually];

    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)choosePhoto:(id)sender
{
    UIActionSheet *choosePhoto = [[UIActionSheet alloc] initWithTitle:@"How do you want to select a picture?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take Picture", @"Choose Picture", nil];
    [choosePhoto showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self takePicture];
    } else if (buttonIndex == 1) {
        [self choosePicture];
    }
}

- (void)takePicture
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *noCamera = [[UIAlertView alloc] initWithTitle:@"Error"
                                                           message:@"This device does not seem to have a camera."
                                                          delegate:self
                                                 cancelButtonTitle:@"Ok"
                                                 otherButtonTitles:nil, nil];
        [noCamera show];
    } else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker
                           animated:YES
                         completion:nil];
    }
}

- (void)choosePicture
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker
                       animated:YES
                     completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    photo1Field.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    UIAlertView *noCamera = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                       message:@"Seems like picking a photo didn't really work out for you."
                                                      delegate:self
                                             cancelButtonTitle:@"Ok"
                                             otherButtonTitles:nil, nil];
    [noCamera show];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImageToDisk:(UIImage *)imageToSave {
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docs = [paths objectAtIndex:0];
    
    //replace this with the appropriate image name.  Maybe random?
    NSString *nextName = [[NSString alloc] initWithFormat:@"/photo1.jpg"];
    NSString *path = [docs stringByAppendingString:nextName];
    
    
    NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(imageToSave, 80)];
    NSError *writeError = nil;
    [imageData writeToFile:path options:NSDataWritingAtomic error:&writeError];
    
    if(writeError!=nil){
        NSLog(@"%@: Error saving image: %@", [self class], [writeError localizedDescription]);
    }
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
