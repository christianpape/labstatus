//
//  LabStatusPanel.h
//  LabStatus
//
//  Created by Christian Pape on 07.10.08.
//  Copyright 2008 cc-productions. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface LabStatusPanel : NSPanel {
	IBOutlet NSPanel* labStatusPanel;
	IBOutlet NSView* labStatusView;
}

- (id)init;
- (BOOL)canBecomeMainWindow;
- (BOOL)isExcludedFromWindowsMenu;
- (void)awakeFromNib;

@end
