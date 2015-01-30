//
//  AddDogViewController.h
//  Assessment4
//
//  Created by Vik Denic on 8/11/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Person;
@class Dog;

@interface AddDogViewController : UIViewController

@property NSManagedObjectContext *context;
@property Person *owner;
@property Dog *dog;

@end
