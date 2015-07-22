//
//  RecipeViewController.m
//  FACCookbook
//
//  Created by Aaron Eisses on 2015-05-02.
//  Copyright (c) 2015 EAC. All rights reserved.
//

#import "RecipeViewController.h"

@implementation RecipeViewController

- (void) viewDidAppear:(BOOL) animated {
  [super viewDidAppear:animated];
}

- (void) viewDidLoad {
  [super viewDidLoad];
    
    UIScrollView *scrollView = (UIScrollView *) self.view;
    [scrollView setContentOffset:CGPointMake(0, scrollView.contentOffset.y)];

  /*
  UIImageView *recipeImageView = (UIImageView *)[self.view viewWithTag:100];
  recipeImageView.image = [UIImage imageNamed:self.imgPath];
   */
    self.instructions.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec eleifend augue vehicula porttitor tincidunt. Praesent ornare dui non fermentum convallis. Phasellus at egestas velit, in elementum turpis. In consectetur elit sit amet luctus pulvinar. Sed mattis nisl a lectus semper, vel gravida nisi blandit. Ut convallis lobortis viverra. Quisque vitae commodo enim, vitae sollicitudin nunc. Vestibulum quis mollis purus. Quisque pretium purus a egestas tempus. Sed sagittis iaculis risus ut tempor. Morbi aliquet congue mi sit amet facilisis. Praesent consequat est gravida vestibulum sodales. Sed dictum ornare purus, ut ullamcorper est placerat non.";
  
  NSLog(@"View has loaded");
}

@end
