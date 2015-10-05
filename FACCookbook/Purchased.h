//
//  Purchased.h
//  FACCookbook
//
//  Created by Amisha Goyal on 7/22/15.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Purchased : NSManagedObject

@property (nonatomic, retain) NSManagedObject *recipe;
@property (nonatomic, retain) NSNumber *purchasedId;

@end
