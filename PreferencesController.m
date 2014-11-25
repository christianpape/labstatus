//
//  PreferencesController.m
//  LabStatus
//
//  Created by Christian Pape on 07.10.08.
//  Copyright 2008 cc-productions. All rights reserved.
//

#import "PreferencesController.h"
#import "Host.h"

@implementation PreferencesController

- (id)init
{
	if (![super initWithWindowNibName:@"PreferencesPanel"])
		return nil;
	
  if (!preferences) {
    preferences = [[Preferences alloc] init];
  }

  hosts = [preferences hosts];
  indicators = [preferences indicators];
  actions = [preferences actions];
  progress = [preferences progress];
	
  return self;
}

- (void)setHosts:(NSMutableArray*)a
{
	hosts = a;
}

- (void)setIndicators:(NSMutableArray*)a
{
	indicators = a; 
}

- (void)setActions:(NSMutableArray*)a
{
	actions = a;
}

- (void)windowWillClose:(NSNotification *)notification
{
  [preferences setHosts:hosts];
  [preferences setIndicators:indicators];
  [preferences setActions:actions];
  [preferences setProgress:progress];
	
  [NSApp stopModal];
}

- (IBAction) showPasswordSheet:(id)sender
{
  [NSApp beginSheet:passwordSheet
     modalForWindow:[self window]
      modalDelegate:nil
     didEndSelector:NULL
        contextInfo:NULL];
}

- (IBAction) cancelPasswordSheet:(id)sender
{
  [NSApp endSheet:passwordSheet];
  [passwordSheet orderOut:sender];
}

- (IBAction) confirmPasswordSheet:(id)sender
{
  [NSApp endSheet:passwordSheet];
  [passwordSheet orderOut:sender];
  
  NSString *username = [usernameTextField stringValue];
  NSString *password = [passwordTextField stringValue];
  
  NSEnumerator * enumeratorHosts = [hosts objectEnumerator];
  Host* host;
  int h = 0;
  
  while(host = [enumeratorHosts nextObject])
  {   
    [host setUsername:username];
    [host setPassword:password];
    h++;
  }
  
}


@end
