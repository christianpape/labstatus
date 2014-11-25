//
//  Host.m
//  LabStatus
//
//  Created by Christian Pape on 07.10.08.
//  Copyright 2008 cc-productions. All rights reserved.
//

#import "Host.h"

@implementation Host

- (id)init
{
	[super init];
  
  // initilizing new host
  
	hostname = NSLocalizedString(@"LABSTATUS_NEW_HOST",@"");
	ipAddress = @"0.0.0.0";
	macAddress = @"00:00:00:00:00:00";
  username = @"";
  password = @"";
	
	return self;
}

- (void) loadPassword
{
  if (!username)
    username = @"";
  
  if (!password)
    password = @"";
  
  if ([[self username] isEqualToString:@""] || [[self hostname] isEqualToString:@""]) 
    [self setPassword:@""];
  else {
    Keychain *keychain = [[Keychain alloc] init];
    [self setPassword: [keychain getKeychainPassword:[self hostname] username:[self username]]];
  }  
}

- (void) savePassword
{
  if (![[self username] isEqualToString:@""] && ![[self password] isEqualToString:@""] && ![[self hostname] isEqualToString:@""]) {
    Keychain *keychain = [[Keychain alloc] init];
    [keychain addKeyChainEntry:[self hostname] username:[self username] password:[self password]];
  }
}

- (int)createTextField:(int)position hosts:(NSMutableArray*)hosts view:(NSView*)view
{
  // creating text field for hostname
  
  NSRect rectTextView = NSMakeRect(10, ([hosts count]*20)-(position+1)*20 + 2, MAXFLOAT, 20);
  textView = [[NSTextField alloc] initWithFrame:rectTextView];
  
  [textView setEditable:NO];
  [textView setSelectable:NO];
  [textView setBezeled:NO];
  [textView setDrawsBackground:NO];  
  [textView setTextColor:[NSColor whiteColor]];
  [textView setFont:[NSFont userFontOfSize:11.0]];
  [textView setStringValue:[self hostname]];

  // auto-size textfield
  
  [textView sizeToFit];
  
  // adding to view 
  
  [view addSubview:textView];    

  // returns size of frame
  
  NSRect r = [textView frame];
  return r.size.width;
}

- (void)createControls:(int)position offset:(int)offset width:(int)width hosts:(NSMutableArray*)hosts indicators:(NSMutableArray*)indicators actions:(NSMutableArray*)actions view:(NSView*)view
{
  indicatorStatus = [[NSMutableArray alloc] init];
  indicatorControls = [[NSMutableArray alloc] init];
  actionControls = [[NSMutableArray alloc] init];
  
  int hosts_count = [hosts count];
  int indicators_count = [indicators count];

  // creating indicators
  NSEnumerator * enumeratorIterators = [indicators objectEnumerator];
  Indicator* indicator;
  int i = 0;
   
  while(indicator = [enumeratorIterators nextObject])
  {    
    NSRect rectImageView = NSMakeRect(offset+(width*i), (hosts_count*20)-(position+1)*20, 20, 20);       
    IndicatorView  *indicatorView = [[IndicatorView alloc] initWithFrame:rectImageView];
            
    [view addSubview:indicatorView];
    [indicatorControls addObject:indicatorView];
    [indicatorStatus addObject: [NSNumber numberWithInteger:-1]];
    
    i++;
  }   
  
  // creating actions
  NSEnumerator * enumeratorActions = [actions objectEnumerator];
  Action* action;
  int a = 0;
    
  while(action = [enumeratorActions nextObject])
  {
    NSRect rectImageButton = NSMakeRect(offset+(width*indicators_count)+(width*a), ([hosts count]*20)-(position+1)*20, 20, 20);    
    ActionButton *button = [[ActionButton alloc] initWithFrame:rectImageButton];
    
    NSString *command = [action command];
    
    command = [command stringByReplacingOccurrencesOfString:@"%hostname%" withString: [self hostname]];
    command = [command stringByReplacingOccurrencesOfString:@"%ipaddress%" withString: [self ipAddress]];
    command = [command stringByReplacingOccurrencesOfString:@"%macaddress%" withString: [self macAddress]];
    command = [command stringByReplacingOccurrencesOfString:@"%username%" withString: [self username]];
    command = [command stringByReplacingOccurrencesOfString:@"%password%" withString: [self password]];
    
    command = [command stringByAppendingString:@" 1>/dev/null 2>&1"];
    
    [button setCommand:command];
    
    [view addSubview:button];
    [actionControls addObject:button];
    
    a++;
  }  
}

- (NSControl*)indicatorControl:(int)index
{
  return [indicatorControls objectAtIndex:index];
}

- (int)setIndicatorStatus:(int)index status:(int)status;
{
  NSNumber *number = [indicatorStatus objectAtIndex:index];
  int oldValue = [number intValue];
  
  IndicatorView *indicatorView = [indicatorControls objectAtIndex:index];

  [indicatorView setState:status];
  
  [indicatorStatus replaceObjectAtIndex:index withObject: [NSNumber numberWithInt:status]];
  
  return oldValue;
}

- (void)removeControls
{
  NSEnumerator * enumeratorIndicatorControls = [indicatorControls objectEnumerator];	
  NSControl* control;
  
  while(control = [enumeratorIndicatorControls nextObject])
    [control removeFromSuperview];

  NSEnumerator * enumeratorActionControls = [actionControls objectEnumerator];	
  
  while(control = [enumeratorActionControls nextObject])
    [control removeFromSuperview];
  
  [textView removeFromSuperview];
}

- (id)initWithCoder:(NSCoder *)coder{
	[super init];
	[coder decodeValueOfObjCType:@encode(NSString *) at:&hostname];
	[coder decodeValueOfObjCType:@encode(NSString *) at:&ipAddress];
	[coder decodeValueOfObjCType:@encode(NSString *) at:&macAddress];
	[coder decodeValueOfObjCType:@encode(NSString *) at:&username];
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder{
	[coder encodeValueOfObjCType:@encode(NSString *) at:&hostname];
	[coder encodeValueOfObjCType:@encode(NSString *) at:&ipAddress];
	[coder encodeValueOfObjCType:@encode(NSString *) at:&macAddress];
	[coder encodeValueOfObjCType:@encode(NSString *) at:&username];
}

@synthesize hostname;
@synthesize ipAddress;
@synthesize macAddress;
@synthesize username;
@synthesize password;

@end
