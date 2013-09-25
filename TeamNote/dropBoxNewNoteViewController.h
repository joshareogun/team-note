//
//  dropBoxNewNoteViewController.h
//  CloudNote
//
//  Created by Joshua Areogun on 9/12/13.
//  Copyright (c) 2013 Joshua Areogun. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Dropbox/Dropbox.h>

@interface dropBoxNewNoteViewController : UIViewController <UITextViewDelegate, UIAlertViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextView *mainTextView;

@property (weak, nonatomic) NSString *myNoteTitle;

@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@end
