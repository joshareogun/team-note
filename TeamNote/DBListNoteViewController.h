//
//  DBListNoteViewController.h
//  CloudNote
//
//  Created by Joshua Areogun on 9/12/13.
//  Copyright (c) 2013 Joshua Areogun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropBox/Dropbox.h>
#import "dropBoxNewNoteViewController.h"

@interface DBListNoteViewController : UIViewController <UIAlertViewDelegate, UITextViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextView *myTextView;
@property (weak, nonatomic) IBOutlet UITextField *titletextField;

@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;
@property (weak, nonatomic) DBFile *myFile;
@property (weak, nonatomic) NSString *fileTitle;


@end
