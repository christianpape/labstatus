//
//  Action.h
//  LabStatus
//
//  Created by Christian Pape on 07.10.08.
//  Copyright 2008 cc-productions. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Action : NSObject {
  // attributes of an action
	NSString *name;
	NSString *command;
}

// initializer
- (id)init;

// coder & decoder
- (void)encodeWithCoder:(NSCoder *)coder;
- (id)initWithCoder:(NSCoder *)coder;

@property (readwrite, copy) NSString *name;
@property (readwrite, copy) NSString *command;

@end
