//
//  JERCollectionViewController.m
//  Howlr
//
//  Created by Josh Rojas on 4/22/14.
//  Copyright (c) 2014 Joshua Rojas. All rights reserved.
//

#import "JERCollectionViewController.h"
#import <Parse/Parse.h>
#import "JERCollectionViewCell.h"
#import "JEROtherProfileShowViewController.h"

@interface JERCollectionViewController ()

@property (strong, retain) NSNumber *numCells;
@property (strong, retain) NSArray *allUsers;

@end

@implementation JERCollectionViewController

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
    [self queryUsers];
}

- (void) viewDidAppear:(BOOL)animated{
    [self queryUsers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) queryUsers{
    
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" notContainedIn:[[PFUser currentUser] valueForKey:@"blockList"]];
//    PFQuery *query = [PFUser query];
//    [query whereKey:@"location" nearGeoPoint:[[PFUser currentUser] valueForKey:@"location"]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if(!error){
            NSLog(@"Successfully got %d users", objects.count);
            self.numCells = @(objects.count);
            self.allUsers = [[NSArray alloc] initWithArray:objects];
            [self.collectionView reloadData];
        }
    }];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.numCells.integerValue;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"myCell";
    JERCollectionViewCell *cvcell = (JERCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    [cvcell setBackgroundColor:[UIColor whiteColor]];
   
    PFUser *cellUser = [self.allUsers objectAtIndex:indexPath.row];
    PFFile *file = [cellUser valueForKey:@"photo1"];
//    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//        if (!error) {
//            UIImage *img = [UIImage imageWithData:data];
//            [[cvcell photoImageView] setImage:img];
//        }
//    }];
    NSData *data = [file getData];
    UIImage *img = [UIImage imageWithData:data];
    [[cvcell photoImageView] setImage:img];
    cvcell.user = cellUser;
    

    
    return cvcell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    
    JERCollectionViewCell *datasetCell = (JERCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    datasetCell.backgroundColor = [UIColor blueColor]; // highlight selection
    JEROtherProfileShowViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"OtherShow"];
    PFUser *cellUser = datasetCell.user;
    
    vc.cellUser = cellUser;
    [self presentViewController:vc animated:YES completion:nil];

}


-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *datasetCell =[collectionView cellForItemAtIndexPath:indexPath];
    datasetCell.backgroundColor = [UIColor whiteColor]; // Default color
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
