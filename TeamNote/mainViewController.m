//
//  mainViewController.m
//  TeamNote
//
//  Created by Joshua Areogun on 7/26/13.
//  Copyright (c) 2013 Joshua Areogun. All rights reserved.
//

#import "mainViewController.h"

@interface mainViewController ()
{
    NSMutableArray *listArray;
}
@end

@implementation mainViewController

@synthesize mainTextView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self customizeAppearances];
    
}

-(void)customizeAppearances
{
    mainTextView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cream_pixels.png"]];
    
    NSString *currentFilename;
    
    [[UINavigationBar appearance] setTitle:currentFilename];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"settingSegue"])
    {
        [listArray addObject:self.mainTextView.text];
    }
}

@end
