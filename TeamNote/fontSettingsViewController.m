//
//  fontSettingsViewController.m
//  CloudNote
//
//  Created by Joshua Areogun on 9/2/13.
//  Copyright (c) 2013 Joshua Areogun. All rights reserved.
//

#import "fontSettingsViewController.h"

@interface fontSettingsViewController ()

@end

@implementation fontSettingsViewController

@synthesize sizeLabel, typefaceLabel;

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
    [self customizations];

}

-(void)viewWillAppear:(BOOL)animated
{
    [self customizations];
    self.navigationController.toolbarHidden = YES;
}

-(void)customizations
{
    self.navigationItem.title = @"Font Settings";
    
    self.navigationController.toolbarHidden = YES;

    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Avenir Next" size:15.0],NSFontAttributeName,
                                                                    nil] forState:UIControlStateNormal];
    
    NSString *size = [[NSUserDefaults standardUserDefaults] objectForKey:@"finalFontSize"];
    NSString *typeFace = [[NSUserDefaults standardUserDefaults] objectForKey:@"fontName"];
    
    self.sizeLabel.text = size;
    self.typefaceLabel.text = typeFace;
}


@end
