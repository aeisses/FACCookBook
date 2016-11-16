//
//  RecipeViewController.m
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-05-02.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#include <stdlib.h>

#import "RecipeViewController.h"
#import "Direction.h"
#import "Note.h"
#import "Ingredient.h"
#import "UIView+AdjustSize.h"
#import "IngredientsTableCell.h"
#import "FICImageCache.h"
#import "DataService.h"
#import "Categories.h"
#import "SeasonColors.h"
#import "NSString+ConvertToEnum.h"
#import "LineAnimationLayer.h"
#import "FlightAnimationLayer.h"
#import "FlowerAnimationLayer.h"

static NSString *ingredientCellIdentifier = @"IngredientCell";
static NSInteger cellPadding = 42;

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
@property (nonatomic) NSInteger contentHeight;
@property (retain, nonatomic) NSMutableArray *animationArray;
@property (retain, nonatomic) UIView *animationView;

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
@synthesize ingredientsTitle = _ingredientsTitle;
@synthesize ingredientsContainerView = _ingredientsContainerView;
@synthesize instructionsTitle = _instructionsTitle;
@synthesize instructionsContainerView = _instructionsContainerView;
@synthesize notesTitle = _notesTitle;
@synthesize notesContainerView = _notesContainerView;
@synthesize starButton = _starButton;

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    float height = [self recipeImage].frame.size.height;
    if (aScrollView.contentOffset.y > height) {
        [[self titleContainerVerticalOffset] setConstant:aScrollView.contentOffset.y-height];
    } else if (aScrollView.contentOffset.y < 0) {
        [[self titleContainerVerticalOffset] setConstant:0];
    }
}

- (IBAction)backButtonTouched:(id)sender {
    UINavigationController *navigationController = (UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    [navigationController popViewControllerAnimated:YES];
}

- (void)loadImageforRecipe {
    [[self recipeImage] setImage:[UIImage imageNamed:@"iPhoneStandard"]];
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

- (void)createAnimationForSeason:(Season)season {
    switch (season) {
        case Winter: {
            for (int i=0; i<7; i++) {
                LineAnimationLayer *layer = [[LineAnimationLayer alloc] initWithWidth:_titleContainerView.frame.size.width forValue:i ofValue:7 season:season opactiy:0.5f];
                [[[self animationView] layer] addSublayer:layer];
                [layer addAnimations:[self titleContainerView].bounds];
                [[self animationArray] addObject:layer];
            }
            break;
        }
        case Summer: {
            for (int i=0; i<4; i++) {
                FlightAnimationLayer *layer = [[FlightAnimationLayer alloc] initInFrame:_titleContainerView.frame offSet:NO opacity:0.5f];
                [[[self animationView] layer] addSublayer:layer];
                [layer addAnimation];
                [[self animationArray] addObject:layer];
            }
            break;
        }
        case Spring: {
            CGRect frame = (CGRect){_titleContainerView.frame.origin,{_titleContainerView.frame.size.width-100,_titleContainerView.frame.size.height}};
            for (int i=0; i<8; i++) {
                FlowerAnimationLayer *layer = [[FlowerAnimationLayer alloc] initInFrame:frame opacity:0.5f];
                [[[self animationView] layer] addSublayer:layer];
                [layer addAnimation];
                [[self animationArray] addObject:layer];
            }
            break;
        }
        case Autumn: {
            for (int i=0; i<10; i++) {
                LineAnimationLayer *layer = [[LineAnimationLayer alloc] initWithWidth:_titleContainerView.frame.size.width forValue:i ofValue:10 season:season opactiy:0.5f];
                [[[self animationView] layer] addSublayer:layer];
                [layer addAnimations:[self titleContainerView].bounds];
                [[self animationArray] addObject:layer];
            }
            break;
        }
        default: {
            break;
        }
    }
}

- (void)loadRecipe {
    [[self titleContainerVerticalOffset] setConstant:0];
    [[self recipeScrollView] setContentOffset:(CGPoint){0,0}];
    
    _name.text = _recipe.title;
    _starButton.selected = [_recipe.isFavourite boolValue];
    
    [[self name] setTextColor:[SeasonColors titleColor:[[self recipe].season convertToSeasonEnum]]];

    [[self ingredientsTitle] setTextColor:[SeasonColors titleColor:[[self recipe].season convertToSeasonEnum]]];
    [[self instructionsTitle] setTextColor:[SeasonColors titleColor:[[self recipe].season convertToSeasonEnum]]];
    [[self notesTitle] setTextColor:[SeasonColors titleColor:[[self recipe].season convertToSeasonEnum]]];

    [[self ingredientsContainerView] setBackgroundColor:[SeasonColors backgroundColor:[[self recipe].season convertToSeasonEnum]]];
    [[self instructionsContainerView] setBackgroundColor:[SeasonColors backgroundColor:[[self recipe].season convertToSeasonEnum]]];
    [[self notesContainerView] setBackgroundColor:[SeasonColors backgroundColor:[[self recipe].season convertToSeasonEnum]]];

    [self loadImageforRecipe];

    [[self infoButton] setHidden:YES];
    [[self infoButton2] setHidden:YES];
    if ([_recipe.categories count] > 1) {
        for (Categories *category in _recipe.categories) {
            if ([category.category isEqualToString:@"vegan"]) {
                [[self infoButton2] setHidden:NO];
                [[self infoButton2] setImage:[UIImage imageNamed:@"vegan_icon"] forState:UIControlStateNormal];
                [[self infoButton2] setTag:0];
            }
            if ([category.category isEqualToString:@"vegetarian"]) {
                [[self infoButton2] setHidden:NO];
                [[self infoButton2] setImage:[UIImage imageNamed:@"vegetarian_icon"] forState:UIControlStateNormal];
                [[self infoButton2] setTag:1];
            }
            if ([category.category isEqualToString:@"gluten free"]) {
                [[self infoButton] setHidden:NO];
                [[self infoButton] setImage:[UIImage imageNamed:@"gluten_free_icon"] forState:UIControlStateNormal];
                [[self infoButton] setTag:2];
            }
        }
    } else {
        for (Categories *category in _recipe.categories) {
            if ([category.category isEqualToString:@"vegan"]) {
                [[self infoButton] setHidden:NO];
                [[self infoButton] setImage:[UIImage imageNamed:@"vegan_icon"] forState:UIControlStateNormal];
                [[self infoButton] setTag:0];
            }
            if ([category.category isEqualToString:@"vegetarian"]) {
                [[self infoButton] setHidden:NO];
                [[self infoButton] setImage:[UIImage imageNamed:@"vegetarian_icon"] forState:UIControlStateNormal];
                [[self infoButton] setTag:1];
            }
            if ([category.category isEqualToString:@"gluten free"]) {
                [[self infoButton] setHidden:NO];
                [[self infoButton] setImage:[UIImage imageNamed:@"gluten_free_icon"] forState:UIControlStateNormal];
                [[self infoButton] setTag:2];
            }
        }
    }

    CGFloat ingredientsHeight = [[[self recipe] ingredients] count] * 21 + cellPadding;
    [[self ingredientsHeightContraint] setConstant:ingredientsHeight];
    [[self backGroundImageView] setImage:nil];
    [[self backGroundImageView] setBackgroundColor:[SeasonColors backgroundColor:[[self recipe].season convertToSeasonEnum]]];

    _ingredientsDictionary = [NSMutableDictionary new];
    for (Ingredient *ingredient in _recipe.ingredients) {
        NSString *item = ingredient.item;
        LocalIngredient *lIngred = [LocalIngredient new];
        lIngred.amount = [ingredient.amount stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        lIngred.ingredient = [ingredient.ingredient stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        NSMutableArray *ingredArray;
        if (item) {
            if ([_ingredientsDictionary objectForKey:item]) {
                ingredArray = [_ingredientsDictionary objectForKey:item];
            } else {
                ingredArray = [NSMutableArray new];
            }
            [ingredArray addObject:lIngred];
            [_ingredientsDictionary setObject:ingredArray forKey:item];
        } else {
            if (![_ingredientsDictionary objectForKey:@"One_Item"]) {
                ingredArray = [NSMutableArray new];
            } else {
                ingredArray = [_ingredientsDictionary objectForKey:@"One_Item"];
            }
            [ingredArray addObject:lIngred];
            [_ingredientsDictionary setObject:ingredArray forKey:@"One_Item"];
        }
    }

    NSArray *keys = [_ingredientsDictionary allKeys];
    NSInteger sectionCount = [keys count];
    if (sectionCount == 1) {
        sectionCount = 0;
    }
    NSInteger rowCount = 0;
    for (NSString *key in keys) {
        NSArray *array = [_ingredientsDictionary objectForKey:key];
        rowCount += [array count];
    }
    [[self ingredients] setBackgroundColor:[SeasonColors backgroundColor:[[self recipe].season convertToSeasonEnum]]];
    [_ingredients reloadData];

    _instructions.text = @"";
    int counter = 1;
    for (Direction *direction in _recipe.directions) {
        NSString *directionString = [direction.direction stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([_instructions.text isEqualToString:@""]) {
            _instructions.text =  [NSString stringWithFormat:@"%i. %@",counter++,directionString];
        } else {
            _instructions.text = [NSString stringWithFormat:@"%@\r\r%i. %@",_instructions.text,counter++,directionString];
        }
    }

    [[self instructions] adjustHeightAndConstraintToTextSize:_instructionHeightContraint withModifier:cellPadding];
    [[self instructions] setBackgroundColor:[SeasonColors backgroundColor:[[self recipe].season convertToSeasonEnum]]];
    [[self instructions] setTextColor:[SeasonColors textColor:[[self recipe].season convertToSeasonEnum]]];

    _notes.text = @"";
    for (Note *note in _recipe.notes) {
        NSString *noteString = [note.note stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([_notes.text isEqualToString:@""]) {
            _notes.text =  [NSString stringWithFormat:@"%@",noteString];
        } else {
            _notes.text = [NSString stringWithFormat:@"%@\r\r%@",_notes.text,noteString];
        }
    }

    [[self notes] adjustHeightAndConstraintToTextSize:_notesHeightContraint withModifier:cellPadding];
    [[self notes] setBackgroundColor:[SeasonColors backgroundColor:[[self recipe].season convertToSeasonEnum]]];
    [[self notes] setTextColor:[SeasonColors textColor:[[self recipe].season convertToSeasonEnum]]];

    int titleHeight = [[self titleContainerView] frame].size.height;
    [self setContentHeight:titleHeight + _ingredientsHeightContraint.constant + _instructionHeightContraint.constant + _notesHeightContraint.constant];
    [[self view] setNeedsLayout];
}

- (void)alignRecipeViews {
    float newHeight = _ingredients.frame.origin.y+_ingredients.frame.size.height+_instructions.frame.size.height+_instructionToNotesContraint.constant+_notesHeightContraint.constant+20;
    [_recipeScrollView setContentSize:(CGSize){[UIScreen mainScreen].bounds.size.width,newHeight}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAnimationArray:[NSMutableArray new]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadRecipe];

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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // This is duplicated here and in viewWillAppear: to make the scroll work in the inital load of the recipe and to make the recipe not flash
    [self loadRecipe];
    CALayer *mask = [[CALayer alloc] init];
    mask.frame = _titleContainerView.bounds;
    mask.backgroundColor = [UIColor blueColor].CGColor;
    _titleContainerView.layer.mask = mask;
    _animationView = [[UIView alloc] initWithFrame:_titleContainerView.bounds];
    _animationView.layer.mask = mask;
    [_titleContainerView insertSubview:_animationView atIndex:0];
    
    [self createAnimationForSeason:[[self recipe].season convertToSeasonEnum]];
}

- (void)removeAnimations {
    for (CALayer *layer in _animationArray) {
        [layer removeAllAnimations];
        [layer removeFromSuperlayer];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (_showNavigationBar) {
        UINavigationController *navigationController = (UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
        navigationController.navigationBarHidden = YES;
    }
    [self removeAnimations];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.view removeGestureRecognizer:_swipeRightGuesture];
    [self.view removeGestureRecognizer:_swipeLeftGesture];
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
    Season currentSeason = [[self recipe].season convertToSeasonEnum];
    if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self swipeRight];
    } if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self swipeLeft];
    }
    if (currentSeason != [[self recipe].season convertToSeasonEnum]) {
        [self removeAnimations];
        [self createAnimationForSeason:[[self recipe].season convertToSeasonEnum]];
    }
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 21.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([[_ingredientsDictionary allKeys] count] > 1) {
        return 21.0f;
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
    cell.ingredient.textColor = [SeasonColors textColor:[[self recipe].season convertToSeasonEnum]];
    cell.amount.textColor = [SeasonColors textColor:[[self recipe].season convertToSeasonEnum]];

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

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    int recipeHeight = [[self recipeImage] frame].size.height;

    [[self recipeScrollView] setContentSize:(CGSize){self.view.frame.size.width,[self contentHeight] + recipeHeight}];
}

- (IBAction)touchStarButton:(id)sender {
    _starButton.selected = !_starButton.selected;
    // Update in the data service
    _recipe.isFavourite = @(_starButton.selected);
    [[DataService sharedInstance] updateFavouite:_recipe];
}

- (IBAction)touchInfoButton:(id)sender {
    NSString *message = @"";
    switch (((UIButton*)sender).tag) {
        case 0:
            message = @"This recipe is vegan!";
            break;
        case 1:
            message = @"This recipe is vegetarian!";
            break;
        case 2:
        default:
            message = @"This recipe is gluten free!";
            break;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:message delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [alert show];
    
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
