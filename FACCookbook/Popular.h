//
//  Featured.h
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-04-01.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Popular : NSManagedObject

@property (nonatomic, retain) NSManagedObject *recipe;
@property (nonatomic, retain) NSNumber *popularId;

@end
