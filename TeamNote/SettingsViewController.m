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

@synthesize dropBoxSwitch, navBar;

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
    
    BOOL DBStat = [[NSUserDefaults standardUserDefaults] boolForKey:@"DBSupportStatus"];
    
    if (DBStat == YES)
    {
        [dropBoxSwitch setOn:YES animated:YES];
    }
}

-(void)customizeBackbutton
{
    self.navigationController.toolbarHidden = YES;
    
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Avenir Next" size:15.0],NSFontAttributeName,
                                                                   nil] forState:UIControlStateNormal];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.toolbarHidden = NO;
}

- (IBAction)dropBoxSwitchToggled:(id)sender
{
    BOOL dropBoxSupport;
    
    if (self.dropBoxSwitch.isOn)
    {
        dropBoxSupport = YES;
        
        [[DBAccountManager sharedManager] linkFromController:self];
        
        [[NSUserDefaults standardUserDefaults] setBool:dropBoxSupport forKey:@"DBSupportStatus"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    else
    {
        dropBoxSupport = NO;
        
        
        [[[DBAccountManager sharedManager] linkedAccount] unlink];
        
        [[NSUserDefaults standardUserDefaults] setBool:dropBoxSupport forKey:@"DBSupportStatus"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(void)returnToEdit
{
    [self performSegueWithIdentifier:@"settingsSegue" sender:self];
}

@end
