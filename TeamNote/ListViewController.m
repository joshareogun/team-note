//
//  ListViewController.m
//  TeamNote
//
//  Created by Joshua Areogun on 7/27/13.
//  Copyright (c) 2013 Joshua Areogun. All rights reserved.
//

#import "ListViewController.h"
#import "AppDelegate.h"
#import "Note.h"
#import "otherNotesViewController.h"

@interface ListViewController ()
{
    NSMutableArray *allTopics;
    NSMutableArray *allContent;
    NSMutableArray *allDates;
    NSMutableArray *filteredString;
    NSMutableArray *stringDates;
    BOOL isFiltered;
}

@end

@implementation ListViewController

@synthesize  NoteContents, NoteTitles, myTableView, managedObjectContext;

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
    [self customizations];
    [self dataFetch];
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self dataFetch];
    
    [self.myTableView reloadData];
    self.navigationController.toolbarHidden = YES;
}

-(void)customizations
{
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    self.navigationItem.leftBarButtonItem.title = @"Options";
    
    self.navigationItem.title = @"All Notes";
    
    self.navigationController.toolbarHidden = YES;
}

-(void)popCurrentViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dataFetch
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateCreated" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    
    self.NoteTitles = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    allTopics = [[NSMutableArray alloc] init];
    allContent = [[NSMutableArray alloc] init];
    allDates = [[NSMutableArray alloc]init];
    
    for (Note *note in NoteTitles)
    {
        [allTopics addObject:note.title];
        [allContent addObject:note.content];
        [allDates addObject:note.dateCreated];
    }
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [allTopics count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Note *note = [NoteTitles objectAtIndex:indexPath.row];
    
    cell.textLabel.text = note.title;
    cell.textLabel.font = [UIFont fontWithName:@"Avenir Next" size:17.0];
    
    //detailTextlabel goes here!!!
   cell.detailTextLabel.font = [UIFont fontWithName:@"Avenir Next" size:12.0];
    
    NSString *myDate;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    myDate =  [formatter stringFromDate:note.dateCreated];
    
    cell.detailTextLabel.text = myDate;

    
    return cell;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    if (editing)
    {
        self.editButtonItem.title = NSLocalizedString(@"Done", @"Done");
    }
    else
    {
        self.editButtonItem.title = NSLocalizedString(@"Options", @"Options");
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSManagedObject *itemToDelete = [NoteTitles objectAtIndex:indexPath.row];
        [managedObjectContext deleteObject:itemToDelete];
        
        [allTopics removeObjectAtIndex:indexPath.row];
        [allContent removeObjectAtIndex:indexPath.row];
        [allDates removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
        
        NSError *error = nil;
        if (![managedObjectContext save:&error]) {
            NSLog(@"UnSaved Context Bro!!");
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"archiveDetail"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        otherNotesViewController *destinationVC = segue.destinationViewController;
        
        destinationVC.noteTitle = [allTopics objectAtIndex:indexPath.row];
        destinationVC.noteContent = [allContent objectAtIndex:indexPath.row];
        destinationVC.noteDate = [stringDates objectAtIndex:indexPath.row];
    }
}

@end
