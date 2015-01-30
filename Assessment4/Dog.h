//
//  Dog.h
//  Assessment4
//
//  Created by Yi-Chin Sun on 1/30/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Dog : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * breed;
@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSManagedObject *owner;

@end
