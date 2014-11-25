//
//  Preferences.m
//  LabStatus
//
//  Created by Christian Pape on 07.10.08.
//  Copyright 2008 cc-productions. All rights reserved.
//

#import "Preferences.h"

NSString * const labStatusHosts = @"Hosts";
NSString * const labStatusIndicators = @"Indicators";
NSString * const labStatusActions = @"Actions";
NSString * const labStatusProgress = @"ProgressIndicator";

static NSMutableArray* hosts;
static NSMutableArray* indicators;
static NSMutableArray* actions;
static NSNumber* progress;

@implementation Preferences

- (id)init
{
  if (![super init])
    return nil;
	
  [self initializeDefaults];
  
  return self;
}

- (void)initializeDefaults
{
  //hosts = nil;
  //indicators = nil;
  //actions = nil;
	
  NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
  
  // Archive the array objects
  NSData *hostsAsData = [NSKeyedArchiver archivedDataWithRootObject:[[NSMutableArray alloc] init]];
  [defaultValues setObject:hostsAsData forKey:labStatusHosts];
	
  NSData *indicatorsAsData = [NSKeyedArchiver archivedDataWithRootObject:[[NSMutableArray alloc] init]];
  [defaultValues setObject:indicatorsAsData forKey:labStatusIndicators];
	
  NSData *actionsAsData = [NSKeyedArchiver archivedDataWithRootObject:[[NSMutableArray alloc] init]];
  [defaultValues setObject:actionsAsData forKey:labStatusActions];

  NSData *progressAsData = [NSKeyedArchiver archivedDataWithRootObject:[[NSNumber alloc] init]];
  [defaultValues setObject:progressAsData forKey:labStatusProgress];
  
  // Register the dictionary of defaults
  [[NSUserDefaults standardUserDefaults] registerDefaults: defaultValues];
	//NSLog(@"Preferences initializeDefaults");
}


- (NSMutableArray*) hosts 
{ 
  if (!hosts) {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	  
    NSData *hostsAsData = [defaults objectForKey:labStatusHosts];
    hosts = [NSKeyedUnarchiver unarchiveObjectWithData:hostsAsData];
  }	
	//NSLog(@"Preferences hosts");
  return hosts;
}

- (NSMutableArray*) indicators
{ 
  if (!indicators) {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *indicatorsAsData = [defaults objectForKey:labStatusIndicators];
    indicators = [NSKeyedUnarchiver unarchiveObjectWithData:indicatorsAsData];
  }
	//NSLog(@"Preferences indicators");
  return indicators;
}

- (NSMutableArray*) actions
{ 
	if (!actions) {
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSData *actionsAsData = [defaults objectForKey:labStatusActions];
		actions = [NSKeyedUnarchiver unarchiveObjectWithData:actionsAsData];
	}
	//NSLog(@"Preferences actions");
	return actions;
}

- (int) progress
{ 
	if (!progress) {
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSData *progressAsData = [defaults objectForKey:labStatusProgress];
		progress = [NSKeyedUnarchiver unarchiveObjectWithData:progressAsData];
	}
	//NSLog(@"Preferences progress");
	return [progress intValue];
}

- (void)setHosts:(NSMutableArray*)a
{
  hosts = a;
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSData *hostsAsData = [NSKeyedArchiver archivedDataWithRootObject:hosts];
  [defaults setObject:hostsAsData forKey:labStatusHosts];
	//NSLog(@"Preferences setHosts");  
}

- (void)setIndicators:(NSMutableArray*)a
{
  indicators = a;
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
  NSData *indicatorsAsData = [NSKeyedArchiver archivedDataWithRootObject:indicators];
  [defaults setObject:indicatorsAsData forKey:labStatusIndicators];
	//NSLog(@"Preferences setIndicators");  
}

- (void)setActions:(NSMutableArray*)a
{
	actions = a;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSData *actionsAsData = [NSKeyedArchiver archivedDataWithRootObject:actions];
	[defaults setObject:actionsAsData forKey:labStatusActions];
	//NSLog(@"Preferences setActions");  
}

- (void)setProgress:(int)a;
{
	progress = [[NSNumber alloc] initWithInt:a];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSData *progressAsData = [NSKeyedArchiver archivedDataWithRootObject:progress];
	[defaults setObject:progressAsData forKey:labStatusProgress];
	//NSLog(@"Preferences setProgress");  
}

@end
