//
//  IndicatorView.h
//  LabStatus
//
//  Created by Christian Pape on 09.10.08.
//  Copyright 2008 cc-productions. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface IndicatorView : NSImageView {
  int state;
}

- (id)initWithFrame:(NSRect)frameRect;
- (void)setState:(int)newState;

@end
