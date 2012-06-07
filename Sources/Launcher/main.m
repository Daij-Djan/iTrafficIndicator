//
//  main.m
//  iPhoneLikeIndicator
//
//  Created by Dominik Pich on 12.09.09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppController.h"

int main(int argc, const char *argv[])
{
#pragma unused(argc)
#pragma unused(argv)
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	if(LSRegisterURL((CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]], YES) != noErr) {
		return -1;
	}
	
	int status = -1;
    AppController *controller = [[[AppController alloc] init] autorelease];
    [[NSApplication sharedApplication] setDelegate:controller]; //Assuming you want it as your app delegate, which is likely
    status = NSApplicationMain(argc, argv);

	[pool drain];
	return status;
}
