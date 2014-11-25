//
//  PopUpPanel.m
//  LabStatus
//
//  Created by Christian Pape on 07.10.08.
//  Copyright 2008 cc-productions. All rights reserved.
//

#import "PopUpPanel.h"


@implementation PopUpPanel

- (id)init 
{
	if (![super init])
		return nil;
	
  isOpen = NO;
  
	return self;
}

- (void)awakeFromNib
{
  // setting the behaviour concernig spaces
	[self setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces];
  
	[self setAlphaValue:0.0];
	[self setLevel:NSStatusWindowLevel];
  [self fadeIn];
  isOpen = YES;
}

-(void)fadeIn
{
	//[[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
	[self orderFront:self];
  [self setFloatingPanel:YES];
  [self setBecomesKeyOnlyIfNeeded:YES];
	[[self animator] setAlphaValue:1.0];
  isOpen = YES;
}

- (BOOL)isOpen
{
  return isOpen;
}

- (void)fadeOut
{
	[[self animator] setAlphaValue:0.0];
  isOpen = NO;
}

@end
