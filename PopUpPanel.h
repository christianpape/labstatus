//
//  PopUpPanel.h
//  LabStatus
//
//  Created by Christian Pape on 07.10.08.
//  Copyright 2008 cc-productions. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PopUpPanel : NSPanel {
  BOOL isOpen;
}

- (id)init;
- (void)awakeFromNib;
- (void)fadeIn;
- (void)fadeOut;
- (BOOL)isOpen;

@end
