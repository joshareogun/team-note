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
    NSMutableArray * listTitleArray;
    NSString *titleString;
    UIBarButtonItem *doneButton;
}

@end

@implementation mainViewController

@synthesize mainTextView, titleBarTextField, originalSettingsButton, navBar, realButton;


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


    listTitleArray = [[NSMutableArray alloc] init];
    
    [super viewDidLoad];
	
    [self registerForKeyboardNotifications];
    
    [self customizeAppearances];
    
    mainTextView.delegate = self;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
}

-(void)customizeAppearances
{
    mainTextView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cream_pixels.png"]];
    
    //NSString *currentFilename;
    
    self.navigationItem.title = titleString;
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


- (IBAction)editingEnded:(id)sender
{
     titleString =  titleBarTextField.text;
    [listTitleArray addObject:titleString];
    
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditing)];
    
    doneButton.tintColor = [UIColor clearColor];
    
    
    NSMutableArray *myArray = [self.navBar.rightBarButtonItems mutableCopy];
    
    
    [myArray removeObject:originalSettingsButton];
    [myArray insertObject:doneButton atIndex:0];
    
    self.navBar.rightBarButtonItem = [myArray objectAtIndex:0];
    
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
  
    //call AutoSave here. 
    
}


- (void)doneEditing
{
    [[self view] endEditing:YES];
    
    NSMutableArray *myArray = [self.navBar.rightBarButtonItems mutableCopy];
    
    UIButton *myOldButton = [[UIButton alloc] initWithFrame:CGRectMake(271, 3, 44, 38)];
    
    [myOldButton setBackgroundImage:[UIImage imageNamed:@"escheresque_ste.png"] forState:UIControlStateNormal];
    [myOldButton setImage:[UIImage imageNamed:@"lines.png"] forState:UIControlStateNormal];
    [myOldButton addTarget:self action:@selector(moveToSettings) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *superButton = [[UIBarButtonItem alloc] initWithCustomView:myOldButton];
    
    [myArray removeObject:doneButton];
    [myArray insertObject:superButton atIndex:0];
    
    self.navBar.rightBarButtonItem = [myArray objectAtIndex:0];

    
    
}

-(void)moveToSettings
{
    
    [self performSegueWithIdentifier:@"settingsSegue" sender:self];
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

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
