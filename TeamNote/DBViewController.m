//
//  DBViewController.m
//  CloudNote
//
//  Created by Joshua Areogun on 9/12/13.
//  Copyright (c) 2013 Joshua Areogun. All rights reserved.
//

#import "DBViewController.h"
#import "dropBoxNewNoteViewController.h"
#import "DBListNoteViewController.h"

@interface DBViewController ()
{
    BOOL isFiltered;
    NSMutableArray *contents;
    NSString *newNoteTitle;
    NSMutableArray *filteredStrings;
    
}
@end

@implementation DBViewController

@synthesize myTableView, mySearchBar;

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
    [self dataFetch];
    [self customizations];
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.mySearchBar.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self dataFetch];
    [self customizations];
    
    [self.tableView reloadData];
    self.navigationController.toolbarHidden = NO;
}

-(void)customizations
{
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.rightBarButtonItem.title = @"Edit";
    
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Avenir Next" size:15.0],NSFontAttributeName,
                                                                    nil] forState:UIControlStateNormal];
    
    self.navigationItem.title = @"All Notes";
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"Storage" style:UIBarButtonItemStyleBordered target:self action:@selector(popCurrentViewController)];
    
    self.navigationItem.leftBarButtonItem = back;
    
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Avenir Next" size:15.0],NSFontAttributeName,
                                                                   nil] forState:UIControlStateNormal];
    
    CGRect bounds = self.tableView.bounds;
    bounds.origin.y = bounds.origin.y + self.mySearchBar.bounds.size.height;
    self.tableView.bounds = bounds;
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.toolbarHidden = NO;
    
}

-(void)popCurrentViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)dataFetch
{
    DBFilesystem *filesys = [DBFilesystem sharedFilesystem];
    NSArray *cont = [filesys listFolder:[DBPath root] error:nil];
    contents = [NSMutableArray arrayWithArray:cont];
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!contents)
    {
        return 1;
    }
    
    if (isFiltered)
    {
        return [filteredStrings count];
    }
    
    return [contents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!isFiltered)
    {
        DBFileInfo *info = [contents objectAtIndex:indexPath.row];
        
        // Configure the cell...
        cell.textLabel.text = [info.path name];
        cell.textLabel.font = [UIFont fontWithName:@"Avenir Next" size:17.0];
        [cell.textLabel setTextColor:[UIColor colorWithRed:0.3255 green:0.7725 blue:0.6941 alpha:1.0000]];
    }

    else
    {
        cell.textLabel.text = [filteredStrings objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont fontWithName:@"Avenir Next" size:17.0];
        [cell.textLabel setTextColor:[UIColor colorWithRed:0.3255 green:0.7725 blue:0.6941 alpha:1.0000]];

    }
    

    return cell;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0)
    {
        isFiltered = NO;
    }
    else
    {
        isFiltered = YES;
        filteredStrings = [[NSMutableArray alloc] init];
        
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        
        for(DBFileInfo *info in contents)
        {
            [tempArray addObject:info.path.name];
        }
        
        for(NSString *str in tempArray)
        {
            NSRange stringRange = [str rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if (stringRange.location != NSNotFound)
            {
                [filteredStrings addObject:str];
            }
        }
        
    }
    
    [self.myTableView reloadData];
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.mySearchBar resignFirstResponder];
}

-(void) searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.mySearchBar resignFirstResponder];
}

-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.mySearchBar resignFirstResponder];
    [self.myTableView reloadData];
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
        self.editButtonItem.title = NSLocalizedString(@"Edit", @"Edit");
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    DBFilesystem *fileSys = [DBFilesystem sharedFilesystem];
    DBFileInfo *info = [contents objectAtIndex:indexPath.row];
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [fileSys deletePath:info.path error:nil];
        [contents removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }
}

- (IBAction)composeNewNote:(id)sender
{
    [self showMessageInput];
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
         NSLog(@" %@", newNoteTitle);
    }
    
    else if ([button isEqualToString:@"OK"])
    {
        [self performSegueWithIdentifier:@"DBSettingsSegue" sender:self];
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
        [self performSegueWithIdentifier:@"ComposeNewDBNote" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DBListDetail"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        DBListNoteViewController *destVC = segue.destinationViewController;
        
        DBFilesystem *filesys = [DBFilesystem sharedFilesystem];
        
        DBFileInfo *fileInfo = [contents objectAtIndex:indexPath.row];
        
        DBFile *file = [filesys openFile:fileInfo.path error:nil];
        
        destVC.myFile = file;

        
    }
    
    else if ([segue.identifier isEqualToString:@"ComposeNewDBNote"])
    {
        dropBoxNewNoteViewController *destVC = segue.destinationViewController;
        
        destVC.myNoteTitle = newNoteTitle;
        
    }
}
@end
