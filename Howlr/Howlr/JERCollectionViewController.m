//
//  JERCollectionViewController.m
//  Howlr
//
//  Created by Josh Rojas on 4/22/14.
//  Copyright (c) 2014 Joshua Rojas. All rights reserved.
//

#import "JERCollectionViewController.h"
#import <Parse/Parse.h>

@interface JERCollectionViewController ()

@property (strong, retain) NSNumber *numCells;

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) queryUsers{
    PFQuery *query = [PFUser query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if(!error){
            NSLog(@"Successfully got %d users", objects.count);
            self.numCells = @(objects.count);
            [self.collectionView reloadData];
        }
    }];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.numCells.integerValue;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"myCell";
    UICollectionViewCell *cvcell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    UIImageView *imageview = (UIImageView *)[cvcell viewWithTag:100];
    
    //imageview.image = [UIImage imageNamed:@"pin.png"];
    
    [cvcell setBackgroundColor:[UIColor whiteColor]];
    
    return cvcell;
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
