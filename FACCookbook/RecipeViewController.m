//
//  RecipeViewController.m
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-05-02.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import "RecipeViewController.h"
#import "Direction.h"
#import "Note.h"
#import "Ingredient.h"
#import "UIView+AdjustSize.h"
#import "IngredientsTableCell.h"
#import "FICImageCache.h"
#import "DataService.h"

static NSString *ingredientCellIdentifier = @"IngredientCell";

@interface LocalIngredient : NSObject
@property (retain, nonatomic) NSString *amount;
@property (retain, nonatomic) NSString *ingredient;
@end

@implementation LocalIngredient
@synthesize amount;
@synthesize ingredient;

@end

@interface RecipeViewController()
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeRightGuesture;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeLeftGesture;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *instructionHeightContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *notesHeightContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *instructionToNotesContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ingredientsHeightContraint;
@property (strong, nonatomic) NSMutableDictionary *ingredientsDictionary;

- (void)swipeRight;
- (void)swipeLeft;
- (void)swipeHandler:(id)sender;
- (void)alignRecipeViews;

@end

@implementation RecipeViewController

@synthesize recipe = _recipe;
@synthesize recipes = _recipes;
@synthesize showNavigationBar = _showNavigationBar;
@synthesize name = _name;
@synthesize recipeImage = _recipeImage;
@synthesize swipeLeftGesture = _swipeLeftGesture;
@synthesize swipeRightGuesture = _swipeRightGuesture;
@synthesize ingredients = _ingredients;
@synthesize ingredientsDictionary = _ingredientsDictionary;
@synthesize recipeScrollView = _recipeScrollView;
@synthesize backGroundImageView = _backGroundImageView;

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    float height = [self recipeImage].frame.size.height;
    if (aScrollView.contentOffset.y > height) {
        [[self titleContainerHeight] setConstant:aScrollView.contentOffset.y-height];
    } else if (aScrollView.contentOffset.y < 0) {
        [[self titleContainerHeight] setConstant:0];
    }
}

- (IBAction)backButtonTouched:(id)sender {
    UINavigationController *navigationController = (UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    [navigationController popViewControllerAnimated:YES];
}

- (void)loadImageforRecipe {
    [[FICImageCache sharedImageCache] retrieveImageForEntity:_recipe withFormatName:[DataService imageFormat:NO] completionBlock:^(id<FICEntity> entity, NSString *formatName, UIImage *image) {
        @autoreleasepool {
            if (image) {
                [_recipeImage setImage:image];
            } else {
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
                    _recipeImage.image = [UIImage imageNamed:@"iPadStandard"];
                } else {
                    _recipeImage.image = [UIImage imageNamed:@"iPhoneStandard"];
                }
            }
        }
    }];
}

- (void)loadRecipe {
//    _name.text = _recipe.title;
    [self loadImageforRecipe];

//    _backGroundImageView.image = [_recipe imageForSeason];
//    
//    _ingredientsDictionary = [NSMutableDictionary new];
//    for (Ingredient *ingredient in _recipe.ingredients) {
//        NSString *item = ingredient.item;
//        LocalIngredient *lIngred = [LocalIngredient new];
//        lIngred.amount = ingredient.amount;
//        lIngred.ingredient = ingredient.ingredient;
//        
//        NSMutableArray *ingredArray;
//        if (item) {
//            if ([_ingredientsDictionary objectForKey:item]) {
//                ingredArray = [_ingredientsDictionary objectForKey:item];
//            } else {
//                ingredArray = [NSMutableArray new];
//            }
//            [ingredArray addObject:lIngred];
//            [_ingredientsDictionary setObject:ingredArray forKey:item];
//        } else {
//            if (![_ingredientsDictionary objectForKey:@"One_Item"]) {
//                ingredArray = [NSMutableArray new];
//            } else {
//                ingredArray = [_ingredientsDictionary objectForKey:@"One_Item"];
//            }
//            [ingredArray addObject:lIngred];
//            [_ingredientsDictionary setObject:ingredArray forKey:@"One_Item"];
//        }
//    }
//
//    NSArray *keys = [_ingredientsDictionary allKeys];
//    NSInteger sectionCount = [keys count];
//    if (sectionCount == 1) {
//        sectionCount = 0;
//    }
//    NSInteger rowCount = 0;
//    for (NSString *key in keys) {
//        NSArray *array = [_ingredientsDictionary objectForKey:key];
//        rowCount += [array count];
//    }
//
//    _ingredientsHeightContraint.constant = (rowCount+sectionCount)*20;
//    _ingredients.frame = (CGRect){_ingredients.frame.origin,_ingredients.frame.size.width,(rowCount+sectionCount)*20};
////    [_ingredients setNeedsLayout];
//    [_ingredients reloadData];
//
//    _instructions.text = @"";
//    int counter = 1;
//    for (Direction *direction in _recipe.directions) {
//        NSString *directionString = [direction.direction stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//        if ([_instructions.text isEqualToString:@""]) {
//            _instructions.text =  [NSString stringWithFormat:@"%i. %@",counter++,directionString];
//        } else {
//            _instructions.text = [NSString stringWithFormat:@"%@\r%i. %@",_instructions.text,counter++,directionString];
//        }
//    }
//
////    [_instructions adjustHeightAndConstraintToTextSize:_instructionHeightContraint];
//
//    _notes.text = @"";
//    for (Note *note in _recipe.notes) {
//        NSString *noteString = [note.note stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//        if ([_notes.text isEqualToString:@""]) {
//            _notes.text =  [NSString stringWithFormat:@"%@",noteString];
//        } else {
//            _notes.text = [NSString stringWithFormat:@"%@\r%@",_notes.text,noteString];
//        }
//    }

//    [_notes adjustHeightAndConstraintToTextSize:_notesHeightContraint];
}

- (void)alignRecipeViews {
    float newHeight = _ingredients.frame.origin.y+_ingredients.frame.size.height+_instructions.frame.size.height+_instructionToNotesContraint.constant+_notesHeightContraint.constant+20;
    [_recipeScrollView setContentSize:(CGSize){[UIScreen mainScreen].bounds.size.width,newHeight}];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    __weak RecipeViewController *wSelf = self;
    RecipeViewController *sSelf = wSelf;
    _swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:sSelf action:@selector(swipeHandler:)];
    _swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:_swipeLeftGesture];
    
    _swipeRightGuesture = [[UISwipeGestureRecognizer alloc] initWithTarget:sSelf action:@selector(swipeHandler:)];
    _swipeRightGuesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:_swipeRightGuesture];
    
    if (_showNavigationBar) {
        UINavigationController *navigationController = (UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
        navigationController.navigationBarHidden = NO;
    }
}

- (void)viewDidAppear:(BOOL) animated {
    [super viewDidAppear:animated];
    [self loadRecipe];

    CGRect frame = [[self titleContainerView] frame];
    [[self titleContainerView] setBounds:(CGRect){frame.origin.x,_recipeImage.frame.size.height,frame.size}];
//    [_ingredients registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:ingredientCellIdentifier];
//    [self alignRecipeViews];
//    [self layoutIfNeeded];
//    [_instructions setNeedsDisplay];
//    [_ingredients setNeedsLayout];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (_showNavigationBar) {
        UINavigationController *navigationController = (UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
        navigationController.navigationBarHidden = YES;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.view removeGestureRecognizer:_swipeRightGuesture];
    [self.view removeGestureRecognizer:_swipeLeftGesture];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark local methods
- (void)swipeRight {
    NSUInteger index = [_recipes indexOfObject:_recipe];
    if (index > 0) {
        self.recipe = [_recipes objectAtIndex:--index];
        [self loadRecipe];
        [self alignRecipeViews];
    }
}

- (void)swipeLeft {
    NSUInteger index = [_recipes indexOfObject:_recipe];
    if (index < [_recipes count]-1) {
        self.recipe = [_recipes objectAtIndex:++index];
        [self loadRecipe];
        [self alignRecipeViews];
    }
}

- (void)swipeHandler:(id)sender {
    UISwipeGestureRecognizer *gestureRecognizer = (UISwipeGestureRecognizer*)sender;
    if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self swipeRight];
    } if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self swipeLeft];
    }
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 20.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([[_ingredientsDictionary allKeys] count] > 1) {
        return 20.0f;
    }
    return 0.0f;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_ingredientsDictionary objectForKey:[[_ingredientsDictionary allKeys] objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IngredientsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ingredientCellIdentifier];
    
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil];
        cell = (IngredientsTableCell *)[nib objectAtIndex:0];
    }
    
    NSString *item = [[_ingredientsDictionary allKeys] objectAtIndex:indexPath.section];
    NSArray *cellItems = [_ingredientsDictionary objectForKey:item];
    LocalIngredient *lIngred = [cellItems objectAtIndex:indexPath.row];
    
    cell.ingredient.text = lIngred.ingredient;
    cell.amount.text = lIngred.amount;

    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[_ingredientsDictionary allKeys] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *keys = [_ingredientsDictionary allKeys];
    if ([keys count] <= 1) {
        return @"";
    } else {
        return [keys objectAtIndex:section];
    }
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView;                                                    // return list of section titles to display in section index view (e.g. "ABCD...Z#")
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index;  // tell table which section corresponds to section title/index (e.g. "B",1))


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    float height = self.view.frame.size.height + _recipeImage.frame.size.height;
    [[self recipeScrollView] setContentSize:(CGSize){self.view.frame.size.width,1000}];
}
@end
