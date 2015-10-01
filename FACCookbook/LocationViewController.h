//
//  LocationViewController.h
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-05-02.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "InformationViewController.h"
#import "Location.h"

@interface LocationViewController : InformationViewController

@property (retain, nonatomic) Location *location;

@property (strong, nonatomic) IBOutlet UIScrollView *backGroundView;
@property (weak, nonatomic) IBOutlet UILabel *locationTitle;
@property (weak, nonatomic) IBOutlet UIImageView *locationImage;
@property (weak, nonatomic) IBOutlet UILabel *locationEmail;
@property (weak, nonatomic) IBOutlet UILabel *locationPhoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *locationAddress;
@property (weak, nonatomic) IBOutlet UITextView *locationStory;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationStoryHeightContraint;

@end
