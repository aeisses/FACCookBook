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
//    [_locationStory adjustHeightAndConstraintToTextSize:_locationStoryHeightContraint];
    [self loadImageforRecipe];
    self.navigationController.navigationBarHidden = NO;
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
