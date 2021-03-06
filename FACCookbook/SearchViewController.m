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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.collectionView.frame), 44)];
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton = YES;
    self.searchString = @"";
    self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:self.searchBar];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.searchBar
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0
                                                                         constant:44];
    NSLayoutConstraint *topAnchorConstraint = [NSLayoutConstraint constraintWithItem:self.searchBar
                                                                           attribute:NSLayoutAttributeTop
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.view
                                                                           attribute:NSLayoutAttributeTop
                                                                          multiplier:1.0
                                                                            constant:0];
    NSLayoutConstraint *leftAnchorConstraint = [NSLayoutConstraint constraintWithItem:self.searchBar
                                                                            attribute:NSLayoutAttributeLeft
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self.view
                                                                            attribute:NSLayoutAttributeLeft
                                                                           multiplier:1.0
                                                                             constant:0];
    NSLayoutConstraint *rightAnchorConstraint = [NSLayoutConstraint constraintWithItem:self.searchBar
                                                                             attribute:NSLayoutAttributeRight
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.view
                                                                             attribute:NSLayoutAttributeRight
                                                                            multiplier:1.0
                                                                              constant:0];
    [self.view addConstraints:@[topAnchorConstraint, rightAnchorConstraint, leftAnchorConstraint, heightConstraint]];
    
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

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    _searchString = @"";
    self.searchBar.text = @"";
    _recipes = nil;
    [self.collectionView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}

@end

