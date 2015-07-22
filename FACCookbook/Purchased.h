//
//  Featured.h
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-04-01.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Purchased : NSManagedObject

@property (nonatomic, retain) NSOrderedSet *recipes;
@property (nonatomic, retain) NSNumber *purchaseId;

@end
