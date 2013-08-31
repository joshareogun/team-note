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
    NSString *titleString;
    UIBarButtonItem *doneButton;
    BOOL isObjectSaved;

}

@end

@implementation mainViewController

@synthesize mainTextView, titleBarTextField, originalSettingsButton, navBar, realButton, NoteTitles;


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
    mainTextView.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = titleString;
    
    UIButton *myOldButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 3, 41, 29)];
    
    [myOldButton setBackgroundImage:[UIImage imageNamed:@"navTexture"] forState:UIControlStateNormal];
    [myOldButton setImage:[UIImage imageNamed:@"lines.png"] forState:UIControlStateNormal];
    [myOldButton addTarget:self action:@selector(popCurrentViewController) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:myOldButton];
    
    self.navigationItem.leftBarButtonItem = back;
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
    
    if ([self.mainTextView.text length] != 0)
    {
        [self saveFile];
    }
    
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
    
    UIButton *myOldButton = [[UIButton alloc] initWithFrame:CGRectMake(271, 3, 41, 29)];
    
    [myOldButton setBackgroundImage:[UIImage imageNamed:@"navTexture"] forState:UIControlStateNormal];
    [myOldButton setImage:[UIImage imageNamed:@"cog.png"] forState:UIControlStateNormal];
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
    
    NSArray *tempArray = [finalText componentsSeparatedByString:@"\n"];
    
    NSString *theString = [tempArray objectAtIndex:0];
    
    thisNote.title = theString;
    
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
    NSArray *arr = [myString componentsSeparatedByString:@"\n"];
    
    NSString *newTitleString = [arr objectAtIndex:0];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"title == %@",newTitleString ];
    
    [request setPredicate:pred];
    
    NSError *error;
    
    self.NoteTitles = [context executeFetchRequest:request error:&error];
    
    for(Note *note in NoteTitles)
    {
        note.title = newTitleString;
        note.content = myString;
    }
    
    if (![context save:&error])
    {
        NSLog(@"Error Occured while saving the data");
    }

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
