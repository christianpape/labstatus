//
//  Preferences.h
//  LabStatus
//
//  Created by Christian Pape on 07.10.08.
//  Copyright 2008 cc-productions. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString * const labStatusHosts;
extern NSString * const labStatusActions;
extern NSString * const labStatusIndicators;
extern NSString * const labStatusProgress;

@interface Preferences : NSObject {
//	NSMutableArray *hosts;
//	NSMutableArray *indicators;
//	NSMutableArray *actions;
}

- (id)init;
- (void)initializeDefaults;

- (NSMutableArray*)hosts;
- (NSMutableArray*)indicators;
- (NSMutableArray*)actions;
- (int)progress;

- (void)setHosts:(NSMutableArray*)a;
- (void)setIndicators:(NSMutableArray*)a;
- (void)setActions:(NSMutableArray*)a;
- (void)setProgress:(int)a;

@end
