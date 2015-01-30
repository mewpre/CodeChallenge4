//
//  ViewController.m
//  Assessment4
//
//  Created by Vik Denic on 8/11/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "ViewController.h"
#import "DogsViewController.h"
#import "AppDelegate.h"
#import "JSONParser.h"
#import "Person.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property UIAlertView *addAlert;
@property UIAlertView *colorAlert;

@property NSManagedObjectContext *context;
@property NSArray *dogOwnersArray;
@property JSONParser *parser;

@property UIColor *defaultTintColor;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.context = [AppDelegate appDelegate].managedObjectContext;
    self.parser = [[JSONParser alloc]initWithContext:self.context];
    self.title = @"Dog Owners";

    //If there is colorData saved in the NSUserDefaults, set the global tint color
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultColor"];
    if (colorData)
    {
        //Changes tint of navigation bar button items
        self.navigationController.navigationBar.tintColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    }
    [self loadDogOwners];
}

- (void)loadDogOwners
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[Person description]];
    
    //Sorts the list of dog owners by name alphabetically
    NSArray *tempArray = [self.context executeFetchRequest:request error:nil];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    self.dogOwnersArray = [tempArray sortedArrayUsingDescriptors:@[sortDescriptor]];

    //If there are no dog owners in Core Data, read dog owners in from JSON
    if (self.dogOwnersArray.count == 0)
    {
        self.dogOwnersArray = [self.parser getDogOwnersFromJSON];
    }
    [self.myTableView reloadData];
}

#pragma mark - UITableView Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dogOwnersArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"myCell"];
    Person *person = [self.dogOwnersArray objectAtIndex:indexPath.row];
    cell.textLabel.text = person.name;
    return cell;
}

#pragma mark - UIAlertView Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIColor *selectedColor;
    if (buttonIndex == 0)
    {
        selectedColor = [UIColor purpleColor];
    }
    else if (buttonIndex == 1)
    {
        selectedColor = [UIColor blueColor];
    }
    else if (buttonIndex == 2)
    {
        selectedColor= [UIColor orangeColor];
    }
    else if (buttonIndex == 3)
    {
        selectedColor = [UIColor greenColor];
    }
    //Changes tint of navigation bar button items
    self.navigationController.navigationBar.tintColor = selectedColor;

    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:selectedColor];
    [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"defaultColor"];

}

//METHOD FOR PRESENTING USER'S COLOR PREFERENCE
- (IBAction)onColorButtonTapped:(UIBarButtonItem *)sender
{
    self.colorAlert = [[UIAlertView alloc] initWithTitle:@"Choose a default color!"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"Purple", @"Blue", @"Orange", @"Green", nil];
    self.colorAlert.tag = 1;
    [self.colorAlert show];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITableViewCell *selectedCell = sender;
    DogsViewController *dvc = segue.destinationViewController;
    Person *selectedPerson = [self.dogOwnersArray objectAtIndex:[self.myTableView indexPathForCell:selectedCell].row];
    dvc.owner = selectedPerson;
}


@end
