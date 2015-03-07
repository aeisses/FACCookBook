//
//  Note.h
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-03-06.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Recipe.h"

@interface Note : NSManagedObject

@property (nonatomic, retain) NSString *note;
@property (nonatomic, retain) Recipe *recipe;

@end
