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
    self.navigationController.toolbarHidden = YES;
    
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Avenir Next" size:15.0],NSFontAttributeName,
                                                                   nil] forState:UIControlStateNormal];
}

- (IBAction)dropBoxSwitchToggled:(id)sender
{
    [[DBAccountManager sharedManager] linkFromController:self];
}

-(void)returnToEdit
{
    [self performSegueWithIdentifier:@"settingsSegue" sender:self];
}

@end
