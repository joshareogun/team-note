//
//  otherNotesViewController.m
//  TeamNote
//
//  Created by Joshua Areogun on 8/19/13.
//  Copyright (c) 2013 Joshua Areogun. All rights reserved.
//

#import "otherNotesViewController.h"

@interface otherNotesViewController ()

@end

@implementation otherNotesViewController

@synthesize noteContent, noteDate, noteTitle, myTextView;

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
    [self customizeBackbutton];
    
    myTextView.text = noteContent;
    
    self.navigationItem.title = noteTitle;
    self.myTextView.delegate = self;
    
}


-(void)customizeBackbutton
{
    
    UIButton *myOldButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 3, 41, 29)];
    
    [myOldButton setBackgroundImage:[UIImage imageNamed:@"navTexture"] forState:UIControlStateNormal];
    [myOldButton setImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
    [myOldButton addTarget:self action:@selector(popCurrentViewController) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:myOldButton];
    
    self.navigationItem.leftBarButtonItem = back;
}

- (void)popCurrentViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
}

@end
