//
//  HomeScreenViewController.m
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-04-30.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import "HomeScreenViewController.h"
#import "RecipeViewController.h"
#import "Recipe.h"
#import "RecipeCell.h"
#import "Utils.h"
#import "Featured.h"
#import "LineAnimationLayer.h"
#import "FlightAnimationLayer.h"
#import "FlowerAnimationLayer.h"

//static NSString *cellResueIdentifier = @"Cell";

@interface HomeScreenViewController ()
@property (retain, nonatomic) NSMutableArray *animationArray;
@end

@implementation HomeScreenViewController

@synthesize recipes = _recipes;
@synthesize animationView = _animationView;
@synthesize ground = _ground;

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)createAnimationForSeason:(Season)season {
    switch (season) {
        case Winter: {
            for (int i=0; i<20; i++) {
                LineAnimationLayer *layer = [[LineAnimationLayer alloc] initWithWidth:[self collectionView].frame.size.width forValue:i ofValue:20 season:season opactiy:1.0f];
                [[_animationView layer] addSublayer:layer];
                [layer addAnimations:[self collectionView].bounds];
                [[self animationArray] addObject:layer];
            }
            break;
        }
        case Summer: {
            CGRect frame = [self collectionView].frame;
            CGRect frameToUse = (CGRect){frame.origin.x,frame.origin.y+200,frame.size.width,frame.size.height-200-49};
            for (int i=0; i<8; i++) {
                FlightAnimationLayer *layer = [[FlightAnimationLayer alloc] initInFrame:frameToUse offSet:YES opacity:1.0f];
                [[_animationView layer] addSublayer:layer];
                [layer addAnimation];
                [[self animationArray] addObject:layer];
            }
            break;
        }
        case Spring: {
            CGRect frame = (CGRect){[self collectionView].frame.origin,{[self collectionView].frame.size.width,[self collectionView].frame.size.height-49}};
            for (int i=0; i<10; i++) {
                FlowerAnimationLayer *layer = [[FlowerAnimationLayer alloc] initInFrame:frame opacity:1.0f];
                [[_animationView layer] addSublayer:layer];
                [layer addAnimation];
                [[self animationArray] addObject:layer];
            }
            break;
        }
        case Autumn: {
            for (int i=0; i<15; i++) {
                LineAnimationLayer *layer = [[LineAnimationLayer alloc] initWithWidth:[self collectionView].frame.size.width forValue:i ofValue:15 season:season opactiy:1.0f];
                [[_animationView layer] addSublayer:layer];
                [layer addAnimations:[self collectionView].bounds];
                [[self animationArray] addObject:layer];
            }
            break;
        }
        default: {
            break;
        }
    }
}

- (NSString*)getGroundName:(Season)season {
    NSString *name = @"";
    switch (season) {
        case Winter: {
            name = @"winterGround";
            break;
        }
        case Summer: {
            name = @"summerGround";
            break;
        }
        case Spring: {
            name = @"springGround";
            break;
        }
        case Autumn:
        default: {
            name = @"fallGround";
            break;
        }
    }
    return name;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _animationArray = [NSMutableArray new];
    [self createAnimationForSeason:[Utils getCurrentSeason]];
    
    [_ground setImage:[UIImage imageNamed:[self getGroundName:[Utils getCurrentSeason]]]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    for (CALayer *layer in _animationArray) {
        [layer removeAllAnimations];
        [layer removeFromSuperlayer];
    }
}

- (NSFetchedResultsController *)recipes {
    if (_recipes != nil) {
        return _recipes;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Featured" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    
    _recipes = theFetchedResultsController;
    __weak typeof(self) wSelf = self;
    _recipes.delegate = wSelf;
    return _recipes;
}

#pragma mark - Segue protocol methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    RecipeViewController* vc = (RecipeViewController*)segue.destinationViewController;
    [vc setShowNavigationBar:YES];
    [vc setRecipe:self.selectedRecipe];
    NSMutableArray *recipes = [NSMutableArray new];
    for (Featured *featured in [_recipes fetchedObjects]) {
        [recipes addObject:featured.recipe];
    }
    [vc setRecipes:recipes];
}

#pragma UICollectioView Data Source
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.recipes sections][section];
    return [sectionInfo numberOfObjects];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RecipeCell *cell = [cv dequeueReusableCellWithReuseIdentifier:cellResueIdentifier forIndexPath:indexPath];

    Featured *featured = [[_recipes fetchedObjects] objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        [cell addRecipeImage:(Recipe*)featured.recipe forCell:NO];
    } else {
        [cell addRecipeImage:(Recipe*)featured.recipe forCell:YES];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize retval;
    if (indexPath.row == 0) {
        retval = [Utils getSmallStandardSize];
    } else {
        retval = [Utils getSmallCellSize];
    }
    
    return retval;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    CGFloat cellWidth = [Utils getSmallCellSize].width;
    CGFloat screenWidth = [[self view] frame].size.width;
    CGFloat cellSpacing = (screenWidth - cellWidth*2)/3;
    return cellSpacing;
}

@end
