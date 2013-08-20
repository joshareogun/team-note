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

@synthesize shareButton, NoteContents, NoteTitles, myTableView, managedObjectContext;

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
    [self customizeBackbutton];
    [self dataFetch];
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    

    
}

-(void)customizeBackbutton
{
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"connect.png"]];
    
    UIButton *myOldButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 3, 41, 29)];
    
    [myOldButton setBackgroundImage:[UIImage imageNamed:@"navTexture"] forState:UIControlStateNormal];
    [myOldButton setImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
    [myOldButton addTarget:self action:@selector(popCurrentViewController) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:myOldButton];
    
    self.navigationItem.leftBarButtonItem = back;
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
    //allDates = [[NSMutableArray alloc]init];
    
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
