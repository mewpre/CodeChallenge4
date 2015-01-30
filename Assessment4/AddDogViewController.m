//
//  AddDogViewController.m
//  Assessment4
//
//  Created by Vik Denic on 8/11/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "AddDogViewController.h"
#import "Person.h"
#import "Dog.h"

@interface AddDogViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *breedTextField;
@property (weak, nonatomic) IBOutlet UITextField *colorTextField;

@end

@implementation AddDogViewController

//TODO: UPDATE CODE ACCORIDNGLY

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Add Dog";

    self.nameTextField.clearButtonMode = YES;
    self.breedTextField.clearButtonMode = YES;
    self.colorTextField.clearButtonMode = YES;

    //If we are editing an existing dog instead of adding a new one, put existing info in textFields.
    if (self.dog)
    {
        self.nameTextField.text = self.dog.name;
        self.breedTextField.text = self.dog.breed;
        self.colorTextField.text = self.dog.color;
    }
}

- (IBAction)onPressedUpdateDog:(UIButton *)sender
{
    //If adding a new dog, create an instance of new dog.
    if (!self.dog)
    {
        self.dog = [NSEntityDescription insertNewObjectForEntityForName:[Dog description] inManagedObjectContext:self.context];
        [self.dog setOwner:self.owner];
    }
    self.dog.name = self.nameTextField.text;
    self.dog.breed = self.breedTextField.text;
    self.dog.color = self.colorTextField.text;
    
    [self.context save:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
