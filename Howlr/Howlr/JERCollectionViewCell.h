//
//  JERCollectionViewCell.h
//  Howlr
//
//  Created by Josh Rojas on 4/25/14.
//  Copyright (c) 2014 Joshua Rojas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface JERCollectionViewCell : UICollectionViewCell
@property(nonatomic, weak) IBOutlet UIImageView *photoImageView;
@property(nonatomic, strong) PFUser *user;
@end
