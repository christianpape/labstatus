//
//  LabStatusPanel.m
//  LabStatus
//
//  Created by Christian Pape on 07.10.08.
//  Copyright 2008 cc-productions. All rights reserved.
//

#import "LabStatusPanel.h"


@implementation LabStatusPanel

- (id)init
{
	if (![super init])
		return nil;
	
	return self;
}

- (BOOL)canBecomeMainWindow 
{
	// required to behave like a main NSWindow
	return YES;
}

- (BOOL)isExcludedFromWindowsMenu
{
	// required to behave like a main NSWindow
	return NO;
}

- (void)awakeFromNib
{
	// required to behave like a main NSWindow
	[[NSApplication sharedApplication] addWindowsItem:self title:[self title] filename:NO];
	
	// required to behave like a main NSWindow
	[self setHidesOnDeactivate:NO];
	
	// tell the controller to not cascade its windows (required for auto-save)
	[[self windowController] setShouldCascadeWindows:NO];  
	
	// auto-save window positions
	[self setFrameAutosaveName:[self representedFilename]];
	
	// setting the behaviour concernig spaces
	[self setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces];
	//[self setCollectionBehavior:NSWindowCollectionBehaviorDefault];

	// required to behave like a main NSWindow
  [self setFloatingPanel:NO];  
}

@end
