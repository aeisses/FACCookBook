//
//  Featured.h
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-05-07.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject;

@interface Featured : NSManagedObject

@property (nonatomic, retain) NSOrderedSet *recipes;

@end
