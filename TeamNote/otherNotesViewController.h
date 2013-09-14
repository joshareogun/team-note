//
//  otherNotesViewController.h
//  TeamNote
//
//  Created by Joshua Areogun on 8/19/13.
//  Copyright (c) 2013 Joshua Areogun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface otherNotesViewController : UIViewController <UITextViewDelegate, UIAlertViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextView *myTextView;

@property(nonatomic, strong)NSString *noteTitle;
@property(nonatomic, strong)NSString *noteContent;
@property(nonatomic, strong)NSString *noteDate;
@property(nonatomic, strong)NSManagedObjectContext *managedObjectContext; 

@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@property(nonatomic, strong) NSArray *NoteTitles;

@end
