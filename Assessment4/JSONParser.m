//
//  JSONParser.m
//  Assessment4
//
//  Created by Yi-Chin Sun on 1/30/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "JSONParser.h"
#import "Person.h"

@implementation JSONParser

- (instancetype)initWithContext: (NSManagedObjectContext *) context
{
    self = [super init];
    if (self)
    {
        self.context = context;
    }
    return self;
}

- (NSArray *)getDogOwnersFromJSON
{
    NSMutableArray *tempArray = [NSMutableArray new];
    NSString *urlString = @"http://s3.amazonaws.com/mobile-makers-assets/app/public/ckeditor_assets/attachments/25/owners.json";
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

    for (NSString *dogOwner in jsonArray)
    {
        Person *newPerson = [NSEntityDescription insertNewObjectForEntityForName:[Person description] inManagedObjectContext:self.context];
        newPerson.name = dogOwner;
        [tempArray addObject:newPerson];
    }
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [self.context save:nil];
    
    //Return array of dog owners sorted by name
    return [tempArray sortedArrayUsingDescriptors:@[sortDescriptor]];
}

@end
