//
//  DBViewController.m
//  CloudNote
//
//  Created by Joshua Areogun on 9/12/13.
//  Copyright (c) 2013 Joshua Areogun. All rights reserved.
//

#import "DBViewController.h"

@interface DBViewController ()

@end

@implementation DBViewController

@synthesize myTableView;

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
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self dataFetch];
    
    [self.myTableView reloadData];
    self.navigationController.toolbarHidden = NO;
}

-(void)customizations
{
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.rightBarButtonItem.title = @"Edit";
    
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:0.4000 green:0.8000 blue:1.0000 alpha:1.0000];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Avenir Next" size:15.0],NSFontAttributeName,
                                                                    nil] forState:UIControlStateNormal];
    
    self.navigationItem.title = @"All Notes";
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"Storage" style:UIBarButtonItemStyleBordered target:self action:@selector(popCurrentViewController)];
    
    self.navigationItem.leftBarButtonItem = back;
    
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:0.4000 green:0.8000 blue:1.0000 alpha:1.0000];
    
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Avenir Next" size:15.0],NSFontAttributeName,
                                                                   nil] forState:UIControlStateNormal];
    
    self.navigationController.toolbarHidden = NO;
    
}

-(void)popCurrentViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dataFetch
{
   // NSMutableArray *contents = []
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.textLabel.font = [UIFont fontWithName:@"Avenir Next" size:17.0];
    
    //detailTextlabel goes here!!!
    cell.detailTextLabel.font = [UIFont fontWithName:@"Avenir Next" size:12.0];
    
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
        self.editButtonItem.title = NSLocalizedString(@"Edit", @"Edit");
    }
}

@end
