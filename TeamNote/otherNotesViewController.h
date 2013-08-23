//
//  otherNotesViewController.h
//  TeamNote
//
//  Created by Joshua Areogun on 8/19/13.
//  Copyright (c) 2013 Joshua Areogun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface otherNotesViewController : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *myTextView;

@property(nonatomic, strong)NSString *noteTitle;
@property(nonatomic, strong)NSString *noteContent;
@property(nonatomic, strong)NSString *noteDate;
@property(nonatomic, strong)NSManagedObjectContext *managedObjectContext; 

@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;

@property(nonatomic, strong) NSArray *NoteTitles;

@end
