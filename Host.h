//
//  Host.h
//  LabStatus
//
//  Created by Christian Pape on 07.10.08.
//  Copyright 2008 cc-productions. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Indicator.h"
#import "Action.h"
#import "IndicatorView.h"
#import "ActionButton.h"
#import "Keychain.h"

@interface Host : NSObject {
  // host attributes  
	NSString *hostname;
	NSString *ipAddress;
	NSString *macAddress;
  NSString *username;
  NSString *password;
  
  // Text field for hostname
  NSTextField *textView;
  
  // status array
  NSMutableArray *indicatorStatus;
  NSMutableArray *indicatorControls;
  
  // controls arrays
  NSMutableArray *actionControls;
}

// initializers
- (id)init;

// coder & decoder
- (id)initWithCoder:(NSCoder *)coder;
- (void)encodeWithCoder:(NSCoder *)coder;

// methods for creating and accessing controls
- (int)createTextField:(int)position hosts:(NSMutableArray*)hosts view:(NSView*)view;
- (void)createControls:(int)position offset:(int)offset width:(int)width hosts:(NSMutableArray*)hosts indicators:(NSMutableArray*)indicators actions:(NSMutableArray*)actions view:(NSView*)view;
- (void)removeControls;
- (NSControl*)indicatorControl:(int)index;

// method for setting indicator status
- (int)setIndicatorStatus:(int)index status:(int)status;

- (void) savePassword;
- (void) loadPassword;

@property (readwrite, copy) NSString *hostname;
@property (readwrite, copy) NSString *ipAddress;
@property (readwrite, copy) NSString *macAddress;
@property (readwrite, copy) NSString *username;
@property (readwrite, copy) NSString *password;

@end
