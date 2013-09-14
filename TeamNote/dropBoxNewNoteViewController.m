//
//  dropBoxNewNoteViewController.m
//  CloudNote
//
//  Created by Joshua Areogun on 9/12/13.
//  Copyright (c) 2013 Joshua Areogun. All rights reserved.
//

#import "dropBoxNewNoteViewController.h"

@interface dropBoxNewNoteViewController ()
{
    UIBarButtonItem *doneButton;
    NSString *titleString;
    
}
@end

@implementation dropBoxNewNoteViewController

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
    
    mainTextView.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self customizeAppearances];
}

-(void)customizeAppearances
{
    mainTextView.backgroundColor = [UIColor whiteColor];
    
    //self.navigationItem.title = titleString;
    
    UIButton *myOldButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 23)];
    
    [myOldButton setImage:[UIImage imageNamed:@"newLines-01.png"] forState:UIControlStateNormal];
    [myOldButton addTarget:self action:@selector(popCurrentViewController) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:myOldButton];
    
    self.navigationItem.leftBarButtonItem = back;
    self.navigationController.toolbarHidden = NO;
    self.navigationController.hidesBottomBarWhenPushed = YES;
    
    NSString *typeFace = [[NSUserDefaults standardUserDefaults] objectForKey:@"fontName"];
    
    
    NSInteger usedFontSize = [self setFontSize];
    
    self.mainTextView.font = [UIFont fontWithName:typeFace size:usedFontSize];
}

-(void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWasShown:(NSNotification *) notification
{
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, (kbSize.width > kbSize.height ? kbSize.height : kbSize.width), 0);
    self.mainTextView.contentInset = contentInsets;
    self.mainTextView.scrollIndicatorInsets = contentInsets;
}

-(void)keyboardWillBeHidden:(NSNotification *)notification
{
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.mainTextView.contentInset = contentInsets;
    self.mainTextView.scrollIndicatorInsets = contentInsets;
    
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditing)];
    
    doneButton.tintColor = [UIColor colorWithRed:0.3255 green:0.7725 blue:0.6941 alpha:1.0000];
    
    NSMutableArray *myArray = [self.navBar.rightBarButtonItems mutableCopy];
    
    
    [myArray insertObject:doneButton atIndex:0];
    
    self.navBar.rightBarButtonItem = [myArray objectAtIndex:0];
    
}
- (void)doneEditing
{
    [[self view] endEditing:YES];
    
    NSMutableArray *myArray = [self.navBar.rightBarButtonItems mutableCopy];
    
    UIButton *myOldButton = [[UIButton alloc] initWithFrame:CGRectMake(271, 3, 28, 25)];
    
    [myOldButton setImage:[UIImage imageNamed:@"mintCog.png"] forState:UIControlStateNormal];
    [myOldButton addTarget:self action:@selector(moveToSettings) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *superButton = [[UIBarButtonItem alloc] initWithCustomView:myOldButton];
    
    [myArray removeObject:doneButton];
    [myArray insertObject:superButton atIndex:0];
    
    self.navBar.rightBarButtonItem = [myArray objectAtIndex:0];
    
    if ([self.mainTextView.text length] != 0)
    {
        [self runEpicDropBoxTimes];
    }
}

-(void)moveToSettings
{
    
    [self performSegueWithIdentifier:@"settingsSegueDB1" sender:self];
}


-(void)runEpicDropBoxTimes
{
    NSString *epicString = mainTextView.text;
    
    NSArray *temp = [epicString componentsSeparatedByString:@"\n"];
    
    NSString *pathNameString = [temp objectAtIndex:0];
    
    DBPath *newPath = [[DBPath root] childPath:pathNameString];

    DBFile *file = [[DBFilesystem sharedFilesystem] createFile:newPath error:nil];
    
    [file writeString:epicString error:nil];
}

- (IBAction)shareButtonPressed:(id)sender
{
    NSString *sharedText = self.mainTextView.text;
    
    NSArray *SharedData = @[sharedText];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:SharedData applicationActivities:nil];
    
    [self presentViewController:activityViewController animated:YES completion:^{}];
}


- (IBAction)addbuttonPressed:(id)sender
{
    
    
    [mainTextView setText:@""];
    
}

- (IBAction)trashButtonPressed:(id)sender
{
    if (!mainTextView.text.length == 0)
    {
        [self deleteFile];
        
        [mainTextView setText:@""];
    }
}

-(CGFloat)setFontSize
{
    NSString *fontSizeValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"finalFontSize"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    CGFloat fontSize;
    
    if ([fontSizeValue isEqualToString:@"Small"])
    {
        fontSize = 15.0;
    }
    else if ([fontSizeValue isEqualToString:@"Medium"])
    {
        fontSize = 19.0;
    }
    else if ([fontSizeValue isEqualToString:@"Large"])
    {
        fontSize = 25.0;
    }
    
    else
    {
        fontSize = 17.0;
    }
    
    return fontSize;
}

- (void)popCurrentViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)deleteFile
{
    
}


-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
