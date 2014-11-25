//
//  LabStatusController.m
//  LabStatus
//
//  Created by Christian Pape on 07.10.08.
//  Copyright 2008 cc-productions. All rights reserved.
//

#import "LabStatusController.h"
#import "Keychain.h"

@implementation LabStatusController
- (id)init
{
  if (![super init])
    return nil;
  return self;
}

- (void)awakeFromNib
{
  if (!preferences) {
    preferences = [[Preferences alloc] init];
  }

  hosts = [preferences hosts];
  indicators = [preferences indicators];
  actions = [preferences actions];
  progress = [preferences progress];
	
  NSEnumerator * enumeratorHosts = [hosts objectEnumerator];
  Host* host;
  int h = 0;
  
  while(host = [enumeratorHosts nextObject])
  {   
    [host loadPassword];
    h++;
  }
  
  [self createControls];  
}

- (void)taskFinished:(NSNotification *)aNotification 
{
  [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                  name:NSTaskDidTerminateNotification 
                                                object:task];  
  
  Host* host = [hosts objectAtIndex:hostIndex];
  Indicator* indicator = [indicators objectAtIndex:indicatorIndex];
  
  int terminationStatus = [task terminationStatus];
  int oldTerminationStatus = [host setIndicatorStatus:indicatorIndex status:terminationStatus];
  
  if (terminationStatus!=oldTerminationStatus) {
    // values changed -> invoke popup
    if (oldTerminationStatus != -1) {
      if (!popUpController)
        popUpController = [[PopUpController alloc] init];    
    
      [popUpController showWindow:self];
      [popUpController addMessage:[NSString stringWithFormat:NSLocalizedString(@"LABSTATUS_INFORMATION",@""),[indicator name], [host hostname], oldTerminationStatus, terminationStatus]];
    }
  }
	
  if (progress == NSOnState) {
    [progressIndicator removeFromSuperview];
  
    [[host indicatorControl:indicatorIndex] setHidden:NO];
  } 
	
  indicatorIndex++;
  
  if (indicatorIndex>=[indicators count]) {
    indicatorIndex = 0;
    hostIndex++;
  }
  
  if (hostIndex>=[hosts count])
    hostIndex = 0;
  
  
  timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                           target:self
                                         selector:@selector(fireTimer:)
                                         userInfo:nil
                                          repeats:NO];
    
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag 
{
	if (flag) {
		return NO;
	} else {
    [labStatusPanel makeKeyAndOrderFront:nil];
		return YES;
	}	
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
  [task terminate];
  task = nil;
  
  [timer invalidate];
  timer = nil;
  
  return NSTerminateNow;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
  return NO;
}

- (IBAction)showPreferencesPanel:(id)sender
{  
  if (!preferencesController)
    preferencesController = [[PreferencesController alloc] init];
  
  // bugfix for version 0.92 

  if (timer) { 
    [timer invalidate];
    timer = nil;
  }
  
  // bugfix for version 0.92 

  if (progressIndicator) {
    [progressIndicator removeFromSuperview];
    progressIndicator = nil;
  }
  
  [NSApp runModalForWindow:[preferencesController window]];
  
  [self removeControls];
  
  hosts = [preferences hosts];
  indicators = [preferences indicators];
  actions = [preferences actions];
  progress = [preferences progress];
	
  Keychain *keychain = [[Keychain alloc] init];
  [keychain removeKeyChainEntries];
  
  NSEnumerator * enumeratorHosts = [hosts objectEnumerator];
  Host* host;
  int h = 0;
  
  while(host = [enumeratorHosts nextObject])
  {   
    [host savePassword];
    h++;
  }
  
  [self createControls];
}

- (void) resizePanelWithWidth:(int)width height:(int)height
{
  NSRect rect = NSMakeRect([labStatusPanel frame].origin.x, 
                           [labStatusPanel frame].origin.y, 
                           width, 
                           height);
  // NSLog(@"%d", [labStatusPanel frame].origin.y);
  
  [labStatusPanel setFrame:[labStatusPanel frameRectForContentRect:rect] 
                   display:YES 
                   animate:YES];
}

- (void) createControls
{    
  if ([hosts count]==0) {
    
    // No hosts
    
    [self resizePanelWithWidth:200
                        height:100];
    
    if (!infoTextField) {
      NSRect rectInfoTextField = NSMakeRect(10,10,200,80);    
      infoTextField = [[NSTextField alloc] initWithFrame:rectInfoTextField];  
      [infoTextField setEditable:false];
      [infoTextField setSelectable:false];
      [infoTextField setBezeled:NO];
      [infoTextField setDrawsBackground:NO];
      
      [infoTextField setTextColor:[NSColor whiteColor]];
      [infoTextField setStringValue:NSLocalizedString(@"LABSTATUS_UNCONFIGURED",@"")];
      [infoTextField setFont:[NSFont userFontOfSize:12.0]];
      
      [labStatusView addSubview: infoTextField];
    }
    
    return ;
    
  } else {
    if (infoTextField) {
      [infoTextField removeFromSuperview];
      infoTextField = nil;
    }
  }
  
  // initializing array
  
  headerControls = [[NSMutableArray alloc] init];
  
  // enumerating hosts
  
  NSEnumerator * enumeratorHosts = [hosts objectEnumerator];
  Host* host;
  int h = 0;
  
  hostnameWidth = 20;

  while(host = [enumeratorHosts nextObject])
  {   
    int width = [host createTextField:h 
                                hosts:hosts
                                 view:labStatusView];
    
    if (width>hostnameWidth)
      hostnameWidth = width;
    
    h++;
  }
  
  hostnameWidth= hostnameWidth+10;
      
  headerWidth = 20;
  
  NSEnumerator * enumeratorIterators = [indicators objectEnumerator];
  Indicator* indicator;
  int i = 0;
   
  while(indicator = [enumeratorIterators nextObject])
  {
    NSRect rectHeaderField = NSMakeRect(hostnameWidth+(i*20), ([hosts count]*20), 20, 10);    
    NSTextField *headerField = [[NSTextField alloc] initWithFrame:rectHeaderField];
        
    [headerField setEditable:false];
    [headerField setSelectable:false];
    [headerField setBezeled:NO];
    [headerField setDrawsBackground:NO];

    [headerField setTextColor:[NSColor whiteColor]];
    [headerField setStringValue:[indicator name]];
    [headerField setFont:[NSFont userFontOfSize:7.0]];
    [headerField sizeToFit];
    
    //[labStatusView addSubview: headerField];
    [headerControls addObject: headerField];             
    
    NSRect r = [headerField frame];
    if (r.size.width>headerWidth)
      headerWidth = r.size.width;
    
    i++;
  }   
  
  NSEnumerator * enumeratorActions = [actions objectEnumerator];
  Action* action;
  int a = 0;
  
  while(action = [enumeratorActions nextObject])
  {
    NSRect rectHeaderField = NSMakeRect(hostnameWidth+(20*[indicators count])+(a*20), ([hosts count]*20), 20, 10);    
    NSTextField *headerField = [[NSTextField alloc] initWithFrame:rectHeaderField];
    
    [headerField setEditable:false];
    [headerField setSelectable:false];
    [headerField setBezeled:NO];
    [headerField setDrawsBackground:NO];
    
    [headerField setTextColor:[NSColor whiteColor]];
    [headerField setStringValue:[action name]];
    [headerField setFont:[NSFont userFontOfSize:7.0]];
    [headerField sizeToFit];
    
    //[labStatusView addSubview: headerField];
    [headerControls addObject: headerField];        

    NSRect r = [headerField frame];
    if (r.size.width>headerWidth)
      headerWidth = r.size.width;
    
    a++;
  }    

  NSEnumerator * enumeratorHeaderControls = [headerControls objectEnumerator];	
  NSControl* control;
  a = 0;
  while(control = [enumeratorHeaderControls nextObject]) {
    [control setFrameOrigin:  NSMakePoint(hostnameWidth+(a*headerWidth),([hosts count]*20))];
    [labStatusView addSubview: control];
    a++;
  }

  // resize the panel
  
  [self resizePanelWithWidth:hostnameWidth + ([indicators count]+[actions count]) * headerWidth 
                      height:10 + ([hosts count] * 20)];
  
  enumeratorHosts = [hosts objectEnumerator];
  h = 0;
  
  while(host = [enumeratorHosts nextObject])
  {   
    [host createControls:h 
                  offset:hostnameWidth
                   width:headerWidth
                   hosts:hosts
              indicators:indicators 
                 actions:actions
                    view:labStatusView];
    h++;
  }
  
	  
  indicatorIndex = 0;
  hostIndex = 0;
  
  [self startTimer];
}

- (void) startTimer
{
  if (timer) { 
    [timer invalidate];
    timer = nil;
  }

  timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                           target:self
                                         selector:@selector(fireTimer:)
                                         userInfo:nil
                                          repeats:NO];
}

- (void) fireTimer:(NSTimer*)aTimer
{
  // do check here
  
  Host* host = [hosts objectAtIndex:hostIndex];
  
  NSRect rectProgressIndicator = NSMakeRect(hostnameWidth+(headerWidth*indicatorIndex), 
                                            ([hosts count]*20)-(hostIndex+1)*20, 
                                            20, 
                                            20);  
  
  // bugfix for version 0.92
  
  if (progressIndicator) {
    [progressIndicator removeFromSuperview];
    progressIndicator = nil;
  }
  
  if (progress == NSOnState) {
    progressIndicator = [[NSProgressIndicator alloc] initWithFrame:rectProgressIndicator];
  
    [progressIndicator setIndeterminate:YES];
    [progressIndicator setStyle:NSProgressIndicatorSpinningStyle];
    [progressIndicator startAnimation:self];
  
    [[host indicatorControl:indicatorIndex] setHidden:YES];
  
    [labStatusView addSubview:progressIndicator];
  }
	
  task = [[NSTask alloc] init];
  
  // get command 
    
  Indicator* indicator = [indicators objectAtIndex:indicatorIndex];
  
  // insert tags
  
  NSString *command = [indicator command];
  
  command = [command stringByReplacingOccurrencesOfString:@"%hostname%" withString: [host hostname]];
  command = [command stringByReplacingOccurrencesOfString:@"%ipaddress%" withString: [host ipAddress]];
  command = [command stringByReplacingOccurrencesOfString:@"%macaddress%" withString: [host macAddress]];
  command = [command stringByReplacingOccurrencesOfString:@"%username%" withString: [host username]];
  command = [command stringByReplacingOccurrencesOfString:@"%password%" withString: [host password]];
  
  command = [command stringByAppendingString:@" 1>/dev/null 2>&1"];
  
  // execute task
  [task setLaunchPath:@"/bin/sh"];
  
  NSArray *arguments = [NSArray arrayWithObjects: @"-c", command, nil];

  [task setArguments: arguments];

  [[NSNotificationCenter defaultCenter] addObserver:self 
                                           selector:@selector(taskFinished:) 
                                               name:NSTaskDidTerminateNotification 
                                             object:task];  
  
  [task launch];
}

- (void) removeControls
{  
  // removing host controls
  
  NSEnumerator * enumeratorHosts = [hosts objectEnumerator];
  Host* host;
  
  while(host = [enumeratorHosts nextObject])
    [host removeControls];
  
  // removing header controls
  
  NSEnumerator * enumeratorHeaderControls = [headerControls objectEnumerator];	
  NSControl* control;
  
  while(control = [enumeratorHeaderControls nextObject])
    [control removeFromSuperview];
}

@end
