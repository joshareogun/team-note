//
//  mainViewController.h
//  TeamNote
//
//  Created by Joshua Areogun on 7/26/13.
//  Copyright (c) 2013 Joshua Areogun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mainViewController : UIViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *mainTextView;
@property (weak, nonatomic) IBOutlet UITextField *titleBarTextField;

@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *originalSettingsButton;

@property (weak, nonatomic) IBOutlet UIButton *realButton;

@property(nonatomic, strong) NSArray *NoteTitles;

@end
