//
//  StartScreenViewController.m
//  Quickjot
//
//  Created by Joshua Areogun on 9/21/13.
//  Copyright (c) 2013 Joshua Areogun. All rights reserved.
//

#import "StartScreenViewController.h"

@interface StartScreenViewController ()

@end

@implementation StartScreenViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.toolbarHidden = YES;
    
    self.navigationItem.title = @"Locations";
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.toolbarHidden = YES;
    
    self.navigationItem.title = @"Locations";
}

@end
