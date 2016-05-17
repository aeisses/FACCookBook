//
//  SearchViewController.m
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-05-02.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import "SearchViewController.h"

@implementation SearchViewController

@synthesize recipes = _recipes;
@synthesize searchBar = _searchBar;
@synthesize searchString = _searchString;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.collectionView setContentOffset:CGPointMake(0, 0)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.collectionView.frame), 44)];
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchBar.delegate = self;

    self.searchString = @"";
    
    [self.collectionView addSubview:self.searchBar];
    [self.collectionView setContentOffset:CGPointMake(0, 44)];
    [self.collectionView setContentInset:UIEdgeInsetsMake(50, 0, 0, 0)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (id)recipes {
    if (_recipes != nil) {
        return _recipes;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Recipe" inManagedObjectContext:self.managedObjectContext];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"recipeId" ascending:NO];
    
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setEntity:entity];
    if (_searchString && ![_searchString isEqualToString:@""]) {
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"ANY searchItems.item CONTAINS[cd] %@",_searchString];
    }

    _recipes = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    return _recipes;
}

#pragma mark UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    _searchString = @"";
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    _searchString = searchText;
    _recipes = nil;
    [self.collectionView reloadData];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 25, 5, 25);
}

@end

