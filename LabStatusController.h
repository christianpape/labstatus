//
//  LabStatusController.h
//  LabStatus
//
//  Created by Christian Pape on 07.10.08.
//  Copyright 2008 cc-productions. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PreferencesController.h"
#import "PopUpController.h"
#import "Action.h"
#import "Host.h"
#import "Indicator.h"

@interface LabStatusController : NSObject {
  
  // arrays containing configuration
  NSMutableArray *hosts;
  NSMutableArray *indicators;
  NSMutableArray *actions;
  int progress;
  
  // index for the indicator & action controls
  int hostIndex, indicatorIndex;

  // width of controls
  int hostnameWidth;
  int headerWidth;
  
  // Outlets for panel & view
  IBOutlet NSPanel* labStatusPanel;
  IBOutlet NSView* labStatusView;
  
  // array holding header textfields
  NSMutableArray *headerControls;  
  
  // actual running task
  NSTask *task;  
  
  // actual running progress indicator
  NSProgressIndicator *progressIndicator;  
  
  // actual running timer
  NSTimer *timer;
  
  // field for message if unconfigured 
  NSTextField *infoTextField;
  
  // controller for preferences & popup panel
  PopUpController *popUpController;
  PreferencesController *preferencesController;
  
  // Preferences
  Preferences *preferences;
}

- (id)init;

- (void)awakeFromNib;

- (IBAction)showPreferencesPanel:(id)sender;

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication;
- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag;
- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender;

- (void)resizePanelWithWidth:(int)width height:(int)height;
- (void)createControls;
- (void)removeControls;

- (void)startTimer;
- (void)fireTimer:(NSTimer*)aTimer;
- (void)taskFinished:(NSNotification*)aNotification;

@end
