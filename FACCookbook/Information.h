//
//  App.h
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-04-01.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Recipe.h"

@interface Information : NSManagedObject

@property (retain, nonatomic) NSString *baseMediaUrl;
@property (retain, nonatomic) NSString *version;

@end
