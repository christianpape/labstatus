//
//  PopUpController.m
//  LabStatus
//
//  Created by Christian Pape on 07.10.08.
//  Copyright 2008 cc-productions. All rights reserved.
//

#import "PopUpController.h"


@implementation PopUpController

- (id)init
{
	if (![super initWithWindowNibName:@"PopUpPanel"])
		return nil;

	return self;
}

- (void)awakeFromNib
{ 
}

- (void)windowWillClose:(NSNotification *)notification
{
  [popUpPanel fadeOut];
}

- (void)showNextMessage
{
  NSString* message = [popUpMessages objectAtIndex:0];
  [popUpMessages removeObjectAtIndex:0];
  
  [popUpTextField setStringValue:message];
}

- (void)addMessage:(NSString*)message
{
  if (!popUpMessages)
    popUpMessages = [[NSMutableArray alloc] init];

  [popUpMessages addObject:message];
  
  if (![popUpPanel isOpen]) { 
    [self showNextMessage];
    [popUpPanel fadeIn];
  } else {
    if (!popUpTimer) {
      [self showNextMessage];
    }
  }
  
  if (!popUpTimer)
    [self startTimer];
}

- (void)startTimer
{
	popUpTimer = [NSTimer scheduledTimerWithTimeInterval: 2.0
                                                target: self
                                              selector: @selector(fireTimer:)
                                              userInfo: nil
                                               repeats: NO];
}

-(void)fireTimer:(NSTimer*)aTimer
{
  if ([popUpPanel isOpen]) {
    if ([popUpMessages count]>0) {
      [self showNextMessage];
      [self startTimer];
    } else {
      [popUpTimer invalidate];
      popUpTimer = nil;
      [popUpPanel fadeOut];
    }
  } else {
    if ([popUpMessages count]>0) {
      [self showNextMessage];
      [popUpPanel fadeIn];
      [self startTimer];
    } else {
      [popUpTimer invalidate];
      popUpTimer = nil;
      [popUpPanel fadeOut];
    }
  }
}

@end
