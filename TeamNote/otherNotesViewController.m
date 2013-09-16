//
//  otherNotesViewController.m
//  TeamNote
//
//  Created by Joshua Areogun on 8/19/13.
//  Copyright (c) 2013 Joshua Areogun. All rights reserved.
//

#import "otherNotesViewController.h"
#import "AppDelegate.h"
#import "Note.h"

@interface otherNotesViewController ()
{
    BOOL isObjectSaved;
    NSString *titleString;
    NSString *textFieldTitle;
    NSString *currentNoteTitle;
}

@end

@implementation otherNotesViewController

@synthesize noteContent, noteDate, noteTitle, myTextView, NoteTitles, managedObjectContext, navBar, titleTextField;

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
    [self registerForKeyboardNotifications];
    
    currentNoteTitle = noteTitle;
    
    myTextView.text = noteContent;
    isObjectSaved = YES;
    self.navigationItem.title = noteTitle;
    myTextView.delegate = self;
    titleTextField.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self customizeBackbutton];
}

-(void)customizeBackbutton
{
    self.titleTextField.hidden = NO;
    self.titleTextField.text = noteTitle;
    
    myTextView.backgroundColor = [UIColor whiteColor];
    UIButton *myOldButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 3, 30, 23)];
    
    [myOldButton setImage:[UIImage imageNamed:@"whiteLines.png"] forState:UIControlStateNormal];
    [myOldButton addTarget:self action:@selector(popCurrentViewController) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:myOldButton];
    
    self.navigationItem.leftBarButtonItem = back;
    self.navigationController.toolbarHidden = NO;

    
    NSString *typeFace = [[NSUserDefaults standardUserDefaults] objectForKey:@"fontName"];
    
    
    NSInteger usedFontSize = [self setFontSize];
    
    self.myTextView.font = [UIFont fontWithName:typeFace size:usedFontSize];
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
    myTextView.contentInset = contentInsets;
    myTextView.scrollIndicatorInsets = contentInsets;
}



-(void)keyboardWillBeHidden:(NSNotification *)notification
{
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    myTextView.contentInset = contentInsets;
    myTextView.scrollIndicatorInsets = contentInsets;
    
}


-(void)textViewDidBeginEditing:(UITextView *)textView
{
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditing)];
    
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
    
    [myArray insertObject:superButton atIndex:0];
    
    self.navBar.rightBarButtonItem = [myArray objectAtIndex:0];
    
    if(isObjectSaved == YES)
    {
        [self updateFile];
    }
    else
    {
        [self saveFile];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.titleTextField)
    {
        [textField resignFirstResponder];
    }
    
    return YES;

}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    noteTitle = titleTextField.text;
    
    textFieldTitle = titleTextField.text;
    
    //call a title Update Method here
    
    [self updateFileTitle];
}

-(void)moveToSettings
{
    
    [self performSegueWithIdentifier:@"settingsSegue2" sender:self];
}

- (IBAction)shareButtonPressed:(id)sender
{
    NSString *sharedText = self.myTextView.text;
    
    NSArray *SharedData = @[sharedText];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:SharedData applicationActivities:nil];
    
    [self presentViewController:activityViewController animated:YES completion:^{}];
}

- (IBAction)trashButtonPressed:(id)sender
{
    if (!myTextView.text.length == 0)
    {
        [self deleteFile];
        [myTextView setText:@""];
        self.navigationItem.title = @"";
        isObjectSaved = NO;
    }
}

- (IBAction)addButtonPressed:(id)sender
{
   [self showTopicMessage];
}


-(void)showTopicMessage
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Enter Title" message:@"Enter A Title For This Note" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
    
    message.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [message show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *button = [alertView buttonTitleAtIndex:1];
    
    if ([button isEqualToString:@"Done"])
    {
        UITextField *title = [alertView textFieldAtIndex:0];
        noteTitle = title.text;
    }
    
    NSLog(@" %@ ", noteTitle);
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString *button = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([button isEqualToString:@"Done"])
    {
        [self viewDidLoad];
        [myTextView setText:@""];
        isObjectSaved = NO;
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


-(void)saveFile
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    Note *thisNote = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:context];
    
    
    NSString* finalText = self.myTextView.text;
    
    thisNote.content = finalText;
    
    thisNote.title = noteTitle;
    
    thisNote.dateCreated = [NSDate date];
    
    isObjectSaved = YES;
    
    NSError *error = nil;
    
    
    if ([context save:&error])
    {
        NSLog(@"Saved!!!");
        NSLog(@"%@", thisNote.title);
    }
    else
        NSLog(@"Fail hahaha");
    
}


-(void)updateFile
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    self.managedObjectContext = context;
    
    NSString *myString = myTextView.text;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"title == %@",noteTitle ];
    
    [request setPredicate:pred];
    
    NSError *error;
    
    self.NoteTitles = [managedObjectContext executeFetchRequest:request error:&error];
    
    for(Note *note in NoteTitles)
    {
        note.title = noteTitle;
        note.content = myString;
        note.dateCreated = [NSDate date];
    }
    
    if (![managedObjectContext save:&error])
    {
        NSLog(@"Error Occured while saving the data");
    }
}


-(void)updateFileTitle
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:context];
    
    [request setEntity:entity];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"title == %@", currentNoteTitle];
    
    [request setPredicate:pred];
    NSError *error;
    
    self.noteTitles = [context executeFetchRequest:request error:&error];
    
    for(Note *note in NoteTitles)
    {
        note.title = textFieldTitle;
        note.content = myTextView.text;
        note.dateCreated = [NSDate date];
    }
    
    if (![context save:&error])
    {
        NSLog(@"Error Updating the File's Title");
    }
    
    noteTitle = currentNoteTitle;
}

-(void)deleteFile
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    
    NSString *myString = myTextView.text;
    NSArray *arr = [myString componentsSeparatedByString:@"\n"];
    
    NSString *newTitleString = [arr objectAtIndex:0];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"title == %@",newTitleString ];
    
    [request setPredicate:pred];
    
    NSError *error;
    
    self.NoteTitles = [context executeFetchRequest:request error:&error];
    
    NSManagedObject *itemToDelete = [self.NoteTitles objectAtIndex:0];
    [context deleteObject:itemToDelete];
    
    if (![context save:&error])
    {
        NSLog(@"Error Occured while saving the data");
    }
    
    
}
@end
