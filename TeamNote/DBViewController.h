//
//  DBViewController.h
//  CloudNote
//
//  Created by Joshua Areogun on 9/12/13.
//  Copyright (c) 2013 Joshua Areogun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end
