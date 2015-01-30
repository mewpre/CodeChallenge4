//
//  JSONParser.h
//  Assessment4
//
//  Created by Yi-Chin Sun on 1/30/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONParser : NSObject

@property NSManagedObjectContext *context;

- (instancetype)initWithContext: (NSManagedObjectContext *) context;
- (NSArray *)getDogOwnersFromJSON;

@end
