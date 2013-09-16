//
//  mainViewController.m
//  TeamNote
//
//  Created by Joshua Areogun on 7/26/13.
//  Copyright (c) 2013 Joshua Areogun. All rights reserved.
//

#import "mainViewController.h"
#import "Note.h"
#import "AppDelegate.h"


@interface mainViewController ()
{
    NSMutableArray *listArray;
    NSMutableArray * listTitleArray;
    UIBarButtonItem *doneButton;

    NSString *currentNoteTitle;
    NSString *textFieldTitle;
    
    BOOL isObjectSaved;

}

@end

@implementation mainViewController

@synthesize mainTextView, navBar, NoteTitles, myTitle, titleTextField;


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
    
    self.navigationItem.title = myTitle;
    
    currentNoteTitle = myTitle;
    
    [self registerForKeyboardNotifications];
    
    [self customizeAppearances];
    
    mainTextView.delegate = self;
    titleTextField.delegate = self;

}

-(void)viewWillAppear:(BOOL)animated
{
    [self customizeAppearances];
}

-(void)customizeAppearances
{
    self.titleTextField.text = myTitle;
    
    //[titleTextField setBackgroundColor:[UIColor colorWithRed:0.3255 green:0.7725 blue:0.6941 alpha:1.0000]];
    
    mainTextView.backgroundColor = [UIColor whiteColor];
    
    UIButton *myOldButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 23)];
    
    [myOldButton setImage:[UIImage imageNamed:@"whiteLines.png"] forState:UIControlStateNormal];
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
    
    [myOldButton setImage:[UIImage imageNamed:@"superCog.png"] forState:UIControlStateNormal];
    [myOldButton addTarget:self action:@selector(moveToSettings) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *superButton = [[UIBarButtonItem alloc] initWithCustomView:myOldButton];
    
    [myArray removeObject:doneButton];
    [myArray insertObject:superButton atIndex:0];
    
    self.navBar.rightBarButtonItem = [myArray objectAtIndex:0];
    
    if ([self.mainTextView.text length] != 0)
    {
        if (isObjectSaved == NO)
        {
            [self saveFile];
        }
        else
        {
            [self updateFile];
        }
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [titleTextField setHidden:NO];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField == self.titleTextField)
    {
        [textField resignFirstResponder];
    }
    
    return YES;
}

-(void) textFieldDidEndEditing:(UITextField *)textField
{
    
    self.myTitle = titleTextField.text;
    
    textFieldTitle = titleTextField.text;
    
    //call a title Update Method instead
    
    [self updateFileTitle];
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
    [self showTopicMessage];
}

- (IBAction)trashButtonPressed:(id)sender
{
    if (!mainTextView.text.length == 0)
    {
        [self deleteFile];
        isObjectSaved = NO;
        [mainTextView setText:@""];
    }
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
        myTitle = title.text;
    }
    
    NSLog(@" %@ ", myTitle);
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString *button = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([button isEqualToString:@"Done"])
    {
        [self viewDidLoad];
        [mainTextView setText:@""];
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


-(void)moveToSettings
{
    
    [self performSegueWithIdentifier:@"settingsSegue" sender:self];
}

-(void)saveFile
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    Note *thisNote = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:context];
    
    
    NSString* finalText = self.mainTextView.text;
    
    thisNote.content = finalText;
    
    thisNote.title = self.myTitle;
    
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
    
    
    NSString *myString = mainTextView.text;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"title == %@",self.myTitle ];
    
    [request setPredicate:pred];
    
    NSError *error;
    
    self.NoteTitles = [context executeFetchRequest:request error:&error];
    
    for(Note *note in NoteTitles)
    {
        note.title = self.myTitle;
        note.content = myString;
        note.dateCreated = [NSDate date];
    }
    
    if (![context save:&error])
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
    
    self.NoteTitles = [context executeFetchRequest:request error:&error];
    for(Note *note in NoteTitles)
    {
        note.title = textFieldTitle;
        note.content = mainTextView.text;
        note.dateCreated = [NSDate date];
    }
    
    if (![context save:&error])
    {
        NSLog(@"Error Updating the File's title");
    }
    
    self.myTitle = currentNoteTitle;
}

-(void)deleteFile
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"title == %@",self.title];
    
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


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"settingSegue"])
    {
        [self saveFile];
    }
}

- (void)popCurrentViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
