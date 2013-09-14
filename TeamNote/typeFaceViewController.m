//
//  typeFaceViewController.m
//  CloudNote
//
//  Created by Joshua Areogun on 9/2/13.
//  Copyright (c) 2013 Joshua Areogun. All rights reserved.
//

#import "typeFaceViewController.h"

@interface typeFaceViewController ()

{
    NSArray *fontNames;
}
@end

@implementation typeFaceViewController


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
    self.navigationController.toolbarHidden = YES;
    [self appearanceCustomizations];
}


-(void)appearanceCustomizations
{
    self.navigationItem.title = @"Typefaces";
    
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Avenir Next" size:15.0],NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    self.navigationController.toolbarHidden = YES;
    
}

-(void)dataFetch
{
    fontNames = [[NSMutableArray alloc]initWithCapacity:5];
    fontNames = [NSMutableArray arrayWithObjects:@"Avenir Next", @"Helvetica", @"HelveticaNeue-Light", @"Noteworthy", @"Raleway", nil];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [fontNames count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndentifier = @"nameCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    [cell.textLabel setTextColor:[UIColor colorWithRed:0.3255 green:0.7725 blue:0.6941 alpha:1.0000]];
    
    cell.textLabel.text = [fontNames objectAtIndex:indexPath.row];

    if ([cell.textLabel.text isEqualToString:@"Avenir Next"])
    {
        cell.textLabel.font = [UIFont fontWithName:@"Avenir Next" size:17.0];
    }
    
    else if ([cell.textLabel.text isEqualToString:@"Helvetica"])
    {
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
    }
    
    else if ([cell.textLabel.text isEqualToString:@"HelveticaNeue-Light"])
    {
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0];
    }
    else if ([cell.textLabel.text isEqualToString:@"Raleway"])
    {
        cell.textLabel.font = [UIFont fontWithName:@"Raleway" size:17.0];
    }
    
    else
    {
        cell.textLabel.font = [UIFont fontWithName:@"Noteworthy-Light" size:17.0];
    }
    
    NSString *checkDeterminant = [[NSUserDefaults standardUserDefaults] objectForKey:@"fontName"];
    
    if ([cell.textLabel.text isEqualToString:checkDeterminant])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    [self.tableView reloadData];
    
    NSString *myString = cell.textLabel.text;
    
    [[NSUserDefaults standardUserDefaults] setObject:myString forKey:@"fontName"];
    //[[NSUserDefaults standardUserDefaults] setObject:myString forKey:@"ipadFontSize"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"%@", cell.textLabel.text);
}

@end
