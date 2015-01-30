//
//  DogsViewController.m
//  Assessment4
//
//  Created by Vik Denic on 8/11/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "DogsViewController.h"
#import "AddDogViewController.h"
#import "Dog.h"
#import "Person.h"

@interface DogsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *dogsTableView;

@property NSManagedObjectContext *context;
@property NSArray *dogsArray;

@end

@implementation DogsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.context = [self.owner managedObjectContext];
    self.title = @"Dogs";
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadDogs];
}

#pragma mark - UITableView Delegate Methods
//Changes the text of the delete button
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Send to Pound 😢";
}

//Method to enable built-in edit functionality

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//Built-in Method for clicking on delete button
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        //must put deleteRowsAtIndexPaths between table view beginUpdates and endUpdates methods
        [self.dogsTableView beginUpdates];
        //removes row from table view
        [self.dogsTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

        //remove object from relationship and delete from core data
        Dog *deletedDog = [self.dogsArray objectAtIndex:indexPath.row];
        [self.owner removeDogsObject:deletedDog];
        [self.context deleteObject:deletedDog];

        //save changes
        [self.context save:nil];

        //reload data
        [self loadDogs];
        [self.dogsTableView endUpdates];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dogsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"dogCell"];
    Dog *dog = [self.dogsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = dog.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Color: %@, Breed: %@", dog.color, dog.breed];
    return cell;
}

- (void)loadDogs
{
    //Sort list of dogs in alphabetical order by name
    NSArray *tempArray = [self.owner.dogs allObjects];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    self.dogsArray = [tempArray sortedArrayUsingDescriptors:@[sortDescriptor]];

    [self.dogsTableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AddDogViewController *avc = segue.destinationViewController;
    avc.context = self.context;
    avc.owner = self.owner;
    if ([segue.identifier isEqualToString: @"AddDogSegue"])
    {
        avc.dog = nil;
    }
    else
    {
        UITableViewCell *cell = sender;
        Dog *selectedDog = [self.dogsArray objectAtIndex:[self.dogsTableView indexPathForCell:cell].row];
        avc.dog = selectedDog;
    }
}

@end
