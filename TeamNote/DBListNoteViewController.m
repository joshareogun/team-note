//
//  DBListNoteViewController.m
//  CloudNote
//
//  Created by Joshua Areogun on 9/12/13.
//  Copyright (c) 2013 Joshua Areogun. All rights reserved.
//

#import "DBListNoteViewController.h"

@interface DBListNoteViewController ()
{
    UIBarButtonItem *doneButton;
     NSString *newNoteTitle;
    NSString *titleString;
    
    __weak DBListNoteViewController *_self;
    
    NSLayoutConstraint *constraint;
    CGFloat originalConstraint;

}

@end

@implementation DBListNoteViewController

@synthesize myTextView, titletextField, navBar;

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
    
    [self initialDataFetch];
    [self customizeAppearances];
    
    myTextView.delegate = self;
    titletextField.delegate = self;
    
    constraint = self.bottomConstraint;
    originalConstraint = self.bottomConstraint.constant;
    _self = self;
}

-(void)initialDataFetch
{
    self.titletextField.text = self.myFile.info.path.name;
    
    self.fileTitle = self.myFile.info.path.name;
    
    myTextView.text = [self.myFile readString:nil];
}

-(void)customizeAppearances
{
    myTextView.backgroundColor = [UIColor whiteColor];
    
 //   self.titletextField.text = self.fileTitle;
    
    UIButton *myOldButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 23)];
    
    [myOldButton setImage:[UIImage imageNamed:@"whiteLines.png"] forState:UIControlStateNormal];
    [myOldButton addTarget:self action:@selector(popCurrentViewController) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:myOldButton];
    
    self.navigationItem.leftBarButtonItem = back;
    self.navigationController.toolbarHidden = NO;
    self.navigationController.hidesBottomBarWhenPushed = YES;
    
    NSString *typeFace = [[NSUserDefaults standardUserDefaults] objectForKey:@"fontName"];
    
    
    NSInteger usedFontSize = [self setFontSize];
    
    self.myTextView.font = [UIFont fontWithName:typeFace size:usedFontSize];
}

-(void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWasShown:(NSNotification *) notification
{
    NSDictionary *info = [notification userInfo];
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    CGRect frame = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    frame = [window convertRect:frame fromWindow:nil];
    frame = [_self.view convertRect:frame fromView:window];
    
    CGFloat height = CGRectGetHeight(frame);
    
    constraint.constant = originalConstraint + height;
    
    NSTimeInterval duration = [info[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{[_self.view layoutIfNeeded];}];
}

-(void)keyboardWillBeHidden:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    constraint.constant = originalConstraint;
    
    NSTimeInterval duration = [info[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{[_self.view layoutIfNeeded];}];
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
    
    [myOldButton setImage:[UIImage imageNamed:@"superCog.png"] forState:UIControlStateNormal];
    [myOldButton addTarget:self action:@selector(moveToSettings) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *superButton = [[UIBarButtonItem alloc] initWithCustomView:myOldButton];
    
    [myArray removeObject:doneButton];
    [myArray insertObject:superButton atIndex:0];
    
    self.navBar.rightBarButtonItem = [myArray objectAtIndex:0];
    
    if ([self.myTextView.text length] != 0)
    {
        [self updateDropboxFile];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [titletextField setHidden:NO];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.titletextField)
    {
        [textField resignFirstResponder];
    }
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.fileTitle = self.titletextField.text;
    titleString = self.titletextField.text;
    
    [self updateDropboxFileTitle];
}


-(void)moveToSettings
{
    
    [self performSegueWithIdentifier:@"settingsSegueDB2" sender:self];
}

-(void)updateDropboxFile
{
    NSString *pathName =  self.titletextField.text;
    
    DBPath *myPath = [[DBPath root] childPath:pathName];
    
    DBFile *file = [[DBFilesystem sharedFilesystem] openFile:myPath error:nil];
    
    NSString *fileText = self.myTextView.text;
    
    [file writeString:fileText error:nil];
}

-(void)updateDropboxFileTitle
{
    NSString *epicString = myTextView.text;
    
    NSString *finalPath = self.titletextField.text;
    
    DBPath *myPath = [[DBPath root] childPath:finalPath];
    
    [[DBFilesystem sharedFilesystem] deletePath:myPath error:nil];
    
    NSString *newPath = [NSString stringWithFormat:@" %@.txt", titleString];
    
    DBPath *pathReplacement = [[DBPath root] childPath:newPath];
    
    DBFile *fileReplacement = [[DBFilesystem sharedFilesystem] createFile:pathReplacement error:nil];
    
    [fileReplacement writeString:epicString error:nil];
}

- (IBAction)shareButtonPressed:(id)sender
{
    NSString *sharedText = self.myTextView.text;
    
    NSArray *SharedData = @[sharedText];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:SharedData applicationActivities:nil];
    
    [self presentViewController:activityViewController animated:YES completion:^{}];
}


- (IBAction)addbuttonPressed:(id)sender
{
    [self showMessageInput];
}

- (IBAction)trashButtonPressed:(id)sender
{
    
    NSString *pathName =  self.titletextField.text;
    
    DBPath *myPath = [[DBPath root] childPath:pathName];
    
    if (!myTextView.text.length == 0)
    {
        [[DBFilesystem sharedFilesystem] deletePath:myPath error:nil];
    
    }
    
    [self popCurrentViewController];
}

-(void)showMessageInput
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Enter A Title For This Note" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
    
    message.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [message show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *button = [alertView buttonTitleAtIndex:1];
    
    if ([button isEqualToString:@"Done"])
    {
        UITextField *title = [alertView textFieldAtIndex:0];
        newNoteTitle = title.text;
    }
}

-(BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    NSString *input = [[alertView textFieldAtIndex:0] text];
    if([input length] >= 1)
    {
        return YES;
    }
    else
    {
        return NO;
        
    }
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString *button = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([button isEqualToString:@"Done"])
    {
        [self performSegueWithIdentifier:@"newNoteFromListNote" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    dropBoxNewNoteViewController *destVC = segue.destinationViewController;
    
    destVC.myNoteTitle = newNoteTitle;
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


-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
