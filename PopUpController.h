//
//  PopUpController.h
//  LabStatus
//
//  Created by Christian Pape on 07.10.08.
//  Copyright 2008 cc-productions. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PopUpPanel.h"

@interface PopUpController : NSWindowController {
  IBOutlet NSTextField *popUpTextField;
  IBOutlet PopUpPanel *popUpPanel;
  NSTimer* popUpTimer;
  NSMutableArray* popUpMessages;
}

- (id)init;
- (void)awakeFromNib;
- (void)addMessage:(NSString*)message;
- (void)showNextMessage;
- (void)startTimer;
- (void)fireTimer:(NSTimer*)aTimer;


@end
