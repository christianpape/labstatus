//
//  ActionButton.h
//  LabStatus
//
//  Created by Christian Pape on 08.10.08.
//  Copyright 2008 cc-productions. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ActionButton : NSButton {
  NSString* command;
}

- (id)initWithFrame:(NSRect)frameRect;
- (void)setCommand:(NSString*)aCommand;
- (IBAction)invokeAction:(id)sender;

@end
