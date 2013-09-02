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
}

@end

@implementation otherNotesViewController

@synthesize noteContent, noteDate, noteTitle, myTextView, NoteTitles, managedObjectContext, navBar;

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
    isObjectSaved = YES;
    self.navigationItem.title = noteTitle;
    self.myTextView.delegate = self;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self customizeBackbutton];
}

-(void)customizeBackbutton
{
    
    UIButton *myOldButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 3, 41, 29)];
    
    [myOldButton setBackgroundImage:[UIImage imageNamed:@"navTexture"] forState:UIControlStateNormal];
    [myOldButton setImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
    [myOldButton addTarget:self action:@selector(popCurrentViewController) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:myOldButton];
    
    self.navigationItem.leftBarButtonItem = back;
    self.navigationController.toolbarHidden = NO;
}

- (void)popCurrentViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditing)];
    
    doneButton.tintColor = [UIColor clearColor];
    
    NSMutableArray *myArray = [self.navBar.rightBarButtonItems mutableCopy];
    
    [myArray insertObject:doneButton atIndex:0];
    
    self.navBar.rightBarButtonItem = [myArray objectAtIndex:0];
    
}

- (void)doneEditing
{
    [[self view] endEditing:YES];
    
    NSMutableArray *myArray = [self.navBar.rightBarButtonItems mutableCopy];
    
    UIButton *myOldButton = [[UIButton alloc] initWithFrame:CGRectMake(271, 3, 41, 29)];
    
    [myOldButton setBackgroundImage:[UIImage imageNamed:@"navTexture"] forState:UIControlStateNormal];
    [myOldButton setImage:[UIImage imageNamed:@"cog.png"] forState:UIControlStateNormal];
    [myOldButton addTarget:self action:@selector(moveToSettings) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *superButton = [[UIBarButtonItem alloc] initWithCustomView:myOldButton];
    
    [myArray insertObject:superButton atIndex:0];
    
    self.navBar.rightBarButtonItem = [myArray objectAtIndex:0];
    
    NSString* finalText = self.myTextView.text;
    
    NSArray *tempArray = [finalText componentsSeparatedByString:@"\n"];
    
    titleString= [tempArray objectAtIndex:0];
    
    self.navigationItem.title = titleString;
    
    if(isObjectSaved == YES)
    {
        [self updateFile];
    }
    else
    {
        [self saveFile];
    }
    
    
}

-(void)textViewDidEndEditing:(UITextView *)textView
{

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
        isObjectSaved = NO;
    }
}

- (IBAction)addButtonPressed:(id)sender
{
    [myTextView setText:@""];
    isObjectSaved = NO;
    self.navigationItem.title = @"New Note";
}

-(void)saveFile
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    Note *thisNote = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:context];
    
    
    NSString* finalText = self.myTextView.text;
    
    thisNote.content = finalText;
    
    NSArray *tempArray = [finalText componentsSeparatedByString:@"\n"];
    
    titleString= [tempArray objectAtIndex:0];
    
    thisNote.title = titleString;
    
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
    NSArray *arr = [myString componentsSeparatedByString:@"\n"];
    
   titleString = [arr objectAtIndex:0];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"title == %@",titleString ];
    
    [request setPredicate:pred];
    
    NSError *error;
    
    self.NoteTitles = [managedObjectContext executeFetchRequest:request error:&error];
    
    for(Note *note in NoteTitles)
    {
        note.title = titleString;
        note.content = myString;
    }
    
    if (![managedObjectContext save:&error])
    {
        NSLog(@"Error Occured while saving the data");
    }
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
