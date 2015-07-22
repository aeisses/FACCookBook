//
//  RecipeCell.m
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-05-02.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import "RecipeCell.h"

@implementation RecipeCell

- (void)prepareForReuse {
}

- (id) initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor colorWithWhite:0.85f alpha:1.0f];
  }
  
  return self;
}

@end
