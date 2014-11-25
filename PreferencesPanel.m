//
//  PreferencesPanel.m
//  LabStatus
//
//  Created by Christian Pape on 07.10.08.
//  Copyright 2008 cc-productions. All rights reserved.
//

#import "PreferencesPanel.h"


@implementation PreferencesPanel

- (id)init 
{
	if (![super init])
		return nil;
	
	return self;
}

- (void)awakeFromNib
{
	// required to behave like a main NSWindow
	[self setHidesOnDeactivate:NO];
	
	// tell the controller to not cascade its windows (required for auto-save)
	[[self windowController] setShouldCascadeWindows:NO];  
	
	// auto-save window positions
	[self setFrameAutosaveName:[self representedFilename]];
}

@end
