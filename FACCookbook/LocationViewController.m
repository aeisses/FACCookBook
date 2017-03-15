//
//  LocationViewController.m
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-05-02.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import "LocationViewController.h"
#import "UIView+AdjustSize.h"
#import "FICImageCache.h"
#import "DataService.h"
#import "SeasonColors.h"
#import "Utils.h"

@implementation LocationViewController

@synthesize backGroundView = _backGroundView;
@synthesize location = _location;
@synthesize locationTitle = _locationTitle;
@synthesize locationImage = _locationImage;
@synthesize locationEmail = _locationEmail;
@synthesize locationPhoneNumber = _locationPhoneNumber;
@synthesize locationAddress = _locationAddress;
@synthesize locationStory = _locationStory;
@synthesize locationStoryHeightContraint = _locationStoryHeightContraint;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _locationTitle.text = _location.name;
    _locationEmail.text = _location.email;
    _locationPhoneNumber.text = _location.phone;
    _locationAddress.text = _location.address;
    _locationStory.text = _location.story;
    
    _locationTitle.textColor = _locationEmail.textColor = _locationPhoneNumber.textColor = _locationAddress.textColor = _locationStory.textColor = [SeasonColors neturalColorText];
    [[self backGroundView] setBackgroundColor:[SeasonColors neturalColorBackground]];
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:(CGRect){{0,0},self.locationImage.frame.size}
                                ];
    self.locationImage.layer.masksToBounds = NO;
    self.locationImage.layer.shadowColor = [UIColor blackColor].CGColor;
    self.locationImage.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
    self.locationImage.layer.shadowOpacity = 0.5f;
    self.locationImage.layer.shadowPath = shadowPath.CGPath;
    
    [self loadImageforRecipe];
}

- (void)viewWillAppear:(BOOL)animated {
    UINavigationController *navigationController = (UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    UINavigationController *navigationController = (UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    navigationController.navigationBarHidden = YES;
}

- (void)loadImageforRecipe {
    [[FICImageCache sharedImageCache] retrieveImageForEntity:_location withFormatName:[DataService imageFormat:NO] completionBlock:^(id<FICEntity> entity, NSString *formatName, UIImage *image) {
        @autoreleasepool {
            if (image) {
                [_locationImage setImage:image];
            }
        }
    }];
}

- (void)alignRecipeViews {
    float newHeight = _locationStory.frame.origin.y+_locationStory.frame.size.height+20;
    [_backGroundView setContentSize:(CGSize){[UIScreen mainScreen].bounds.size.width,newHeight}];
}

@end
