//
//  Indicator.m
//  LabStatus
//
//  Created by Christian Pape on 07.10.08.
//  Copyright 2008 cc-productions. All rights reserved.
//

#import "Indicator.h"


@implementation Indicator

- (id)init
{
	[super init];
	name = NSLocalizedString(@"LABSTATUS_NEW_INDICATOR",@"");
	command = @"";
	return self;
}

- (id)initWithCoder:(NSCoder *)coder{
	[super init];
	[coder decodeValueOfObjCType:@encode(NSString *) at:&name];
	[coder decodeValueOfObjCType:@encode(NSString *) at:&command];
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder{
	[coder encodeValueOfObjCType:@encode(NSString *) at:&name];
	[coder encodeValueOfObjCType:@encode(NSString *) at:&command];
}

@synthesize name;
@synthesize command;

@end
