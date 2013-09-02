//
//  SettingsViewController.m
//  TeamNote
//
//  Created by Joshua Areogun on 7/27/13.
//  Copyright (c) 2013 Joshua Areogun. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize iCloudSwitch;

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
    
    [self customizeBackbutton];
}

-(void)viewWillAppear:(BOOL)animated
{
     self.navigationController.toolbarHidden = YES;
}

-(void)customizeBackbutton
{
    
    UIButton *myOldButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 3, 41, 29)];
    
    [myOldButton setBackgroundImage:[UIImage imageNamed:@"navTexture"] forState:UIControlStateNormal];
    [myOldButton setImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
    [myOldButton addTarget:self action:@selector(popCurrentViewController) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:myOldButton];
    
    self.navigationItem.leftBarButtonItem = back;
    self.navigationController.toolbarHidden = YES;
    
}

- (void)popCurrentViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)iCloudSwitchToggled:(id)sender
{
    
}

-(void)returnToEdit
{
    [self performSegueWithIdentifier:@"settingsSegue" sender:self];
}

@end
