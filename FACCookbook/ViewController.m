//
//  ViewController.m
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-03-01.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import "ViewController.h"
#import "DataService.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[DataService sharedInstance] loadRecipeData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
