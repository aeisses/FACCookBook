//
//  SearchViewController.h
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-05-02.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import "ParentCollectionViewController.h"

@interface SearchViewController : ParentCollectionViewController <UISearchBarDelegate>

@property (retain, nonatomic) UISearchBar *searchBar;
@property (retain, nonatomic) NSString *searchString;

@end
