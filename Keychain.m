//
//  Keychain.m
//  LabStatus
//
//  Created by Christian Pape on 15.10.08.
//  Copyright 2008 cc-productions. All rights reserved.
//

#import "Keychain.h"

@implementation Keychain

- (id)init
{
  if (![super init])
    return nil;
  
  return self;
}

- (void)removeKeyChainEntries
{
  SecKeychainItemRef item;
	SecKeychainSearchRef search;
  OSStatus status;
	OSErr result;
  
	const char *itemKind = [@"LabStatus" UTF8String];
  
  SecKeychainAttribute attrs[] = {
    { kSecDescriptionItemAttr, strlen(itemKind), (char *)itemKind }
  };
  
  SecKeychainAttributeList attributes = { sizeof(attrs) / sizeof(attrs[0]), attrs };
  
  result = SecKeychainSearchCreateFromAttributes(NULL, kSecInternetPasswordItemClass, &attributes, &search);
  
	while (SecKeychainSearchCopyNext (search, &item) == noErr) {
    status = SecKeychainItemDelete(item);
    if (item)
      CFRelease (item);
    
    if (status != 0) {
      NSLog(@"Error deleting keychain entry: %d\n", (int)status);
    }
    
  }
	if (search)
  	CFRelease(search);  
}

- (void) addKeyChainEntry:(NSString*)hostname username:(NSString*)username password:(NSString*)password
{
  OSStatus status;
  SecKeychainItemRef item = nil;
  const char *itemName = [hostname UTF8String];
  const char *itemKind = [@"LabStatus" UTF8String];
  const char *accountUsername = [username UTF8String];
  const char *accountPassword = [password UTF8String];
  
  SecKeychainAttribute attrs[] = {
    { kSecLabelItemAttr, strlen(itemName), (char *)itemName },
    { kSecDescriptionItemAttr, strlen(itemKind), (char *)itemKind },
    { kSecAccountItemAttr, strlen(accountUsername), (char *)accountUsername },
    { kSecServerItemAttr, strlen(itemName), (char *)itemName }
  };
  SecKeychainAttributeList attributes = { sizeof(attrs) / sizeof(attrs[0]), attrs };
  
  status = SecKeychainItemCreateFromContent(
                                         kSecInternetPasswordItemClass,
                                         &attributes,
                                         strlen(accountPassword),
                                         accountPassword,
                                         NULL, // use the default keychain
                                         NULL,
                                         &item);
  
  if (item) 
    CFRelease(item);
  
}

- (NSString*) getKeychainPassword:(NSString*)hostname username:(NSString*)username
{
  char *passwordData;
  UInt32 passwordLength;
  
  const char *itemName = [hostname UTF8String];
  const char *itemKind = [@"LabStatus" UTF8String];
  const char *accountUsername = [username UTF8String];
  
  SecKeychainSearchRef search;
  SecKeychainItemRef item;

  
  SecKeychainAttribute attrs[] = {
    { kSecLabelItemAttr, strlen(itemName), (char *)itemName },
    { kSecDescriptionItemAttr, strlen(itemKind), (char *)itemKind },
    { kSecAccountItemAttr, strlen(accountUsername), (char *)accountUsername },
  };  
  
  SecKeychainAttributeList attributes = { sizeof(attrs) / sizeof(attrs[0]), attrs };

  OSErr result = SecKeychainSearchCreateFromAttributes(NULL, kSecInternetPasswordItemClass, &attributes, &search);
  
  if (result != noErr) {
    NSLog (@"SecKeychainSearchCreateFromAttributes: %d\n", result);
		CFRelease(search);
    return @"";
  }
  
  NSString *returnPassword = @"";
  
  if (SecKeychainSearchCopyNext (search, &item) == noErr) {
    
    SecKeychainAttribute attrs2[] = {
      { kSecAccountItemAttr },
      { kSecDescriptionItemAttr },
      { kSecLabelItemAttr },
      { kSecModDateItemAttr }
    };  
    
    SecKeychainAttributeList attributes2 = { sizeof(attrs2) / sizeof(attrs2[0]), attrs2 };
        
    OSStatus status = SecKeychainItemCopyContent (item, NULL, &attributes2, &passwordLength, (void**)&passwordData);    

    if (status == noErr) {
      returnPassword = [NSString stringWithCString:passwordData length:passwordLength];
    }
    
    SecKeychainItemFreeContent (&attributes2, passwordData);
    
		CFRelease(item);
		CFRelease(search);
	}  
  
	return returnPassword;
}

@end
