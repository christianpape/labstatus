//
//  Keychain.h
//  LabStatus
//
//  Created by Christian Pape on 15.10.08.
//  Copyright 2008 cc-productions. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include <Security/SecKeychain.h>
#include <Security/SecKeychainItem.h>
#include <Security/SecAccess.h>
#include <Security/SecTrustedApplication.h>
#include <Security/SecACL.h>

@interface Keychain : NSObject {

}

- (id) init;
- (void) removeKeyChainEntries;
- (void) addKeyChainEntry:(NSString*)host username:(NSString*)username password:(NSString*)password;
- (NSString*) getKeychainPassword:(NSString*)hostname username:(NSString*)username;

@end
