//
//  ActionButton.m
//  LabStatus
//
//  Created by Christian Pape on 08.10.08.
//  Copyright 2008 cc-productions. All rights reserved.
//

#import "ActionButton.h"


@implementation ActionButton

- (id)initWithFrame:(NSRect)frameRect
{
  if (![super initWithFrame:frameRect])
    return nil;
  
  [self setImage:[[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"button-up" ofType:@"png"]]];
  [self setAlternateImage:[[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"button-down" ofType:@"png"]]];  
  [self setButtonType:NSMomentaryChangeButton];
  [self setTitle:@""];  
  [self setBordered:NO];
  
  return self;
}

- (void)setCommand:(NSString*)aCommand
{
  // NSLog(aCommand);
  command = aCommand;
  [self setTarget: self];
  [self setAction: @selector(invokeAction:)];
}

- (IBAction)invokeAction:(id)sender
{
  // NSLog(command);
  
  // execute task

  NSTask *task = [[NSTask alloc] init];
  
  [task setLaunchPath:@"/bin/sh"];
  
  NSArray *arguments = [NSArray arrayWithObjects: @"-c", command, nil];
  
  [task setArguments: arguments];
  
  [task launch];
}

@end
