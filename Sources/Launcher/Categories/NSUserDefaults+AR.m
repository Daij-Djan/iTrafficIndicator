//
//  NSUserDefaults+deviceBasedDefaults.m
//  Project
//
//  Created by Dominik Pich on 06.11.09.
//  Copyright 2009 Medicus 42 GmbH. All rights reserved.
//

#import "NSUserDefaults+AR.h"
#import "M42Defaults.h"

#pragma mark -

@implementation NSUserDefaults (AR)

+ (M42Defaults*)arUserDefaults {
	static M42Defaults *defaults = nil;
	
	if(!defaults) {
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
		NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
		basePath = [basePath stringByAppendingPathComponent:BUNDLE_NAME];

		NSString *path = [[basePath stringByAppendingPathComponent:BUNDLE_IDENTIFIER] stringByAppendingPathComponent:@"defaults.plist"];
		defaults = [[M42Defaults alloc] initWithPath:path];
	}
	
	return defaults;
}

@end
