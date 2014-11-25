//
//  PreferencesController.h
//  LabStatus
//
//  Created by Christian Pape on 07.10.08.
//  Copyright 2008 cc-productions. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Preferences.h"

@interface PreferencesController : NSWindowController {
  NSMutableArray* hosts;
  NSMutableArray* indicators;
  NSMutableArray* actions;

  IBOutlet NSButton* progressCheckBox;
  IBOutlet NSPanel* passwordSheet;
  IBOutlet NSTextField* usernameTextField;
  IBOutlet NSSecureTextField* passwordTextField;
  
  int progress;
	
  Preferences* preferences;
}

- (id)init;

- (void)setHosts:(NSMutableArray*)a;
- (void)setIndicators:(NSMutableArray*)a;
- (void)setActions:(NSMutableArray*)a;

- (void)windowWillClose:(NSNotification *)notification;
- (IBAction) showPasswordSheet:(id)sender;
- (IBAction) cancelPasswordSheet:(id)sender;
- (IBAction) confirmPasswordSheet:(id)sender;


@end
