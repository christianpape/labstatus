//
//  IndicatorView.m
//  LabStatus
//
//  Created by Christian Pape on 09.10.08.
//  Copyright 2008 cc-productions. All rights reserved.
//

#import "IndicatorView.h"


@implementation IndicatorView

- (id)initWithFrame:(NSRect)frameRect
{
  if (![super initWithFrame:frameRect])
    return nil;
  
  [self setState:-1];
  
  return self;
}

- (void)setState:(int)newState 
{
  state = newState;
  
  if (state==0)
  	[self setImage:[[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"status-up" ofType:@"png"]]];
  else {	
    if (state==-1)
      [self setImage:[[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"status-unknown" ofType:@"png"]]];
    else
      [self setImage:[[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"status-down" ofType:@"png"]]];
  }
}


@end
