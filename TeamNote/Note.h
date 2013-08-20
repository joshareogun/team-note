//
//  Note.h
//  TeamNote
//
//  Created by Joshua Areogun on 8/17/13.
//  Copyright (c) 2013 Joshua Areogun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Note : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * dateCreated;

@end
