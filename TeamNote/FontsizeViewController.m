//
//  FontsizeViewController.m
//  CloudNote
//
//  Created by Joshua Areogun on 9/2/13.
//  Copyright (c) 2013 Joshua Areogun. All rights reserved.
//

#import "FontsizeViewController.h"

@interface FontsizeViewController ()
{
    NSArray *fontSizes;
    
}
@end

@implementation FontsizeViewController

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
    [self appearanceCustomizations];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self appearanceCustomizations];
    self.navigationController.toolbarHidden = YES;
}

-(void)appearanceCustomizations
{
    self.navigationItem.title = @"Font Sizes";
    
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Avenir Next" size:15.0],NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    self.navigationController.toolbarHidden = YES;
    
}

-(void)dataFetch
{
    fontSizes = [[NSMutableArray alloc]initWithCapacity:3];
    fontSizes = [NSMutableArray arrayWithObjects:@"Small", @"Medium", @"Large", nil];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [fontSizes count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndentifier = @"myCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    cell.textLabel.text = [fontSizes objectAtIndex:indexPath.row];
    
    [cell.textLabel setTextColor:[UIColor colorWithRed:0.3255 green:0.7725 blue:0.6941 alpha:1.0000]];
    
    NSString *checkDeterminant = [[NSUserDefaults standardUserDefaults] objectForKey:@"finalFontSize"];
    
    if ([cell.textLabel.text isEqualToString:checkDeterminant])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"Avenir Next" size:17.0];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    [self.tableView reloadData];
    
    NSString *myString = cell.textLabel.text;
    
    
    
    [[NSUserDefaults standardUserDefaults] setObject:myString forKey:@"finalFontSize"];
    //[[NSUserDefaults standardUserDefaults] setObject:myString forKey:@"ipadFontSize"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"%@", cell.textLabel.text);
}

@end
