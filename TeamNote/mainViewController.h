//
//  mainViewController.h
//  TeamNote
//
//  Created by Joshua Areogun on 7/26/13.
//  Copyright (c) 2013 Joshua Areogun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mainViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *mainTextView;

@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@property(nonatomic, strong) NSArray *NoteTitles;

@property(nonatomic, strong) NSString *myTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end
