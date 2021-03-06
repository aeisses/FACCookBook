//
//  PopularViewController.m
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-05-02.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import "PopularViewController.h"
#import "Popular.h"
#import "RecipeViewCell.h"

@implementation PopularViewController

@synthesize recipes = _recipes;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.collectionView setContentInset:UIEdgeInsetsMake(50, 0, 0, 0)];
}

- (id)recipes {
    if (_recipes != nil) {
        return _recipes;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Popular" inManagedObjectContext:self.managedObjectContext];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"popularId" ascending:NO];
    
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setEntity:entity];

    _recipes = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    return _recipes;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RecipeViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    
    Popular *popular = [_recipes objectAtIndex:indexPath.row];
    [cell addRecipeImage:(Recipe*)popular.recipe forCell:YES];
    
    return cell;
}

@end
