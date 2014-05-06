//
//  JERTableTableViewController.m
//  Howlr
//
//  Created by Josh Rojas on 4/30/14.
//  Copyright (c) 2014 Joshua Rojas. All rights reserved.
//

#import "JERTableTableViewController.h"
#import "JEROtherProfileShowViewController.h"
#import "JERTableViewCell.h"
#import <Parse/Parse.h>

@interface JERTableTableViewController ()


@property (strong, retain) NSNumber *numCells;
@property (strong, retain) NSArray *allUsers;

@end

@implementation JERTableTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    [query whereKey:@"objectId" containedIn:[[PFUser currentUser] valueForKey:@"likes"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if(!error){
            NSLog(@"Successfully got %d users", objects.count);
            self.numCells = @(objects.count);
            self.allUsers = [[NSArray alloc] initWithArray:objects];
            [self.tableView reloadData];
        } else {
            NSLog(@"fuck");
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
//    NSArray *likers = [[PFUser currentUser] valueForKeyPath:@"likes"];
//    return [likers count];
    return self.numCells.integerValue;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JERTableViewCell *cell = (JERTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"myTableCell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSArray *likers = [[PFUser currentUser] valueForKeyPath:@"likes"];
    
    PFQuery *query = [PFUser query];
    [query getObjectWithId:[likers objectAtIndex:indexPath.row]];
    NSArray *user = [query findObjects];
    [[cell textLabel] setText:[[user objectAtIndex:0] valueForKey:@"name"]];    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JERTableViewCell *datasetCell = (JERTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    JEROtherProfileShowViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"OtherShow"];
    PFUser *cellUser = datasetCell.user;
    
    vc.cellUser = cellUser;
    [self presentViewController:vc animated:YES completion:nil];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
