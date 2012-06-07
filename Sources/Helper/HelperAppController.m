//
//  AppController.m
//  iPhoneLikeIndicator
//
//  Created by Dominik Pich on 12.09.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "HelperAppController.h"
#import "ProgressIndicator.h"
#import "MenuMeterNetStats.h"
#import "MenuMeterNetConfig.h"
#import "HelperAppController+MenuMeterMenu.h"
#import "NSUserDefaults+AR.h"

@implementation HelperAppController

- (void)updateNetActivityDisplay:(NSTimer *)timer {
	// Get interval for the sample
	NSTimeInterval currentSampleInterval = 1.0;
	if (lastSampleDate) {
		currentSampleInterval = -[lastSampleDate timeIntervalSinceNow];
	}	
	
	// Load new net data
	NSDictionary *netLoad = [netStats netStatsForInterval:currentSampleInterval];
	
	// Update for next sample
	[lastSampleDate release];
	lastSampleDate = [[NSDate date] retain];

	// find if there is a transfer 
	BOOL anykeyNot0 = NO;

	for (NSString *interfaceName in [netLoad allKeys]) {
		NSDictionary *load = [netLoad objectForKey:interfaceName];

		NSNumber *deltain = [load objectForKey:@"deltain"];
		NSNumber *deltaout = [load objectForKey:@"deltaout"];
		
		if((deltain && [deltain unsignedIntValue] >	minBytes) || (deltaout && [deltaout unsignedIntValue] > minBytes)) {
			anykeyNot0 = YES;
//			NSLog(@"%@ = %@", interfaceName, load);
			break;
		}
	}
	
	//update view
	if(anykeyNot0) {
		[networkIndicator startAnimating];
	}
	else {
		[networkIndicator stopAnimating];
	}

	// Add to history (at least one)
	lastNetData = [netLoad retain];
	lastNetInterval = [[NSNumber numberWithDouble:currentSampleInterval] retain];
	
	// Update for next sample
	[lastSampleDate release];
	lastSampleDate = [[NSDate date] retain];
	
	// If the menu is down force it to update
	if ([networkIndicator isMenuDown]) {
		[self updateMenuWhileDown];
	}	
}

- (void)startListening {
	//setup indicator
	networkIndicator = [[ProgressIndicator alloc] init];
	[networkIndicator setStatusItem:statusItem];
	[networkIndicator setFrame:NSMakeRect(0, 0, 30, 22)];
	[statusItem setView:networkIndicator];
	
	// Setup our menu
	extraMenu = [[NSMenu alloc] initWithTitle:@""];
	// Disable menu autoenabling
	[extraMenu setAutoenablesItems:NO];
	[networkIndicator setMenu:extraMenu];
	
	// Restart the timer
	updateTimer = [NSTimer scheduledTimerWithTimeInterval:1
												   target:self
												 selector:@selector(updateNetActivityDisplay:)
												 userInfo:nil
												  repeats:YES];

	// On newer OS versions we need to put the timer into EventTracking to update while the menus are down
	[[NSRunLoop currentRunLoop] addTimer:updateTimer
								 forMode:NSEventTrackingRunLoopMode];

	// Fake a timer call to config initial values
	[self updateNetActivityDisplay:nil];	
}

#pragma mark NSApplication delegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	//minBytes
	minBytes = [[NSUserDefaults arUserDefaults] integerForKey:MinBytesPrefKey];
	if(minBytes <= 0) minBytes = 1;
	NSLog(@"MinBytes = %ld", minBytes);
	
	// Build our data gatherers
	netStats = [[MenuMeterNetStats alloc] init];
	netConfig = [[MenuMeterNetConfig alloc] init];
	pppControl = [[MenuMeterNetPPP sharedPPP] retain];
	
	//prepare collection state
	lastSampleDate = nil;
	lastNetData = nil;
	lastNetInterval = nil;
	
	//prepare menubar entry
	[self prepareLocalizedData];
	statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
	[self startListening];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Stop the timer
	[updateTimer invalidate];  // Released by the runloop
	updateTimer = nil;

	[statusItem release];
	[networkIndicator release];

	[netStats release];
	[netConfig release];
	//pppControl
	
	[lastSampleDate release];
	[lastNetData release];
	[lastNetInterval release];

	[extraMenu release];
	[updateMenuItems release];
}

///////////////////////////////////////////////////////////////
//
//	Menu actions
//
///////////////////////////////////////////////////////////////

- (void)openNetworkUtil:(id)sender {
	
	if (![[NSWorkspace sharedWorkspace] launchApplication:@"Network Utility.app"]) {
		NSLog(@"MenuMeterNet unable to launch the Network Utility.");
	}
	
} // openNetworkUtil

- (void)openNetworkPrefs:(id)sender {
	
	if (![[NSWorkspace sharedWorkspace] openFile:@"/System/Library/PreferencePanes/Network.prefPane"]) {
		NSLog(@"MenuMeterNet unable to launch the Network Preferences.");
	}
	
} // openNetworkPrefs

- (void)openInternetConnect:(id)sender {
	
	if (![[NSWorkspace sharedWorkspace] launchApplication:@"Internet Connect.app"]) {
		NSLog(@"MenuMeterNet unable to launch the Internet Connect application.");
	}
	
} // openInternetConnect

//- (void)switchDisplay:(id)sender {
//	
//	NSString *interfaceName = [sender representedObject];
//	if (!interfaceName) return;
//	
//	// Sanity the name
//	NSDictionary *newConfig = [netConfig interfaceConfigForInterfaceName:interfaceName];
//	if (!newConfig) return;
//	[preferredInterfaceConfig release];
//	preferredInterfaceConfig = [newConfig retain];
//	
//	// Update prefs
//	[ourPrefs saveNetPreferInterface:interfaceName];
//	[ourPrefs syncWithDisk];
//	// Send the notification to the pref pane
//	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:kPrefPaneBundleID
//																   object:kPrefChangeNotification];
//	
//} // switchDisplay

- (void)copyAddress:(id)sender {
	
	if ([[sender representedObject] count]) {
		[[NSPasteboard generalPasteboard] declareTypes:[NSArray arrayWithObjects:NSStringPboardType, nil]
												 owner:nil];
		NSString *clipContent = [[sender representedObject] componentsJoinedByString:@", "];
		[[NSPasteboard generalPasteboard] setString:clipContent forType:NSStringPboardType];
	} else {
		NSLog(@"MenuMeterNet unable to copy IP addresses to clipboard.");
	}
	
} // copyAddress
//
//- (void)pppConnect:(id)sender {
//	
//	if ([sender representedObject]) {
//		// When we can, use the SC utility function.
//		if (isPantherOrLater) {
//			// SC connection
//			SCNetworkConnectionRef connection = SCNetworkConnectionCreateWithServiceID(
//																					   kCFAllocatorDefault,
//																					   (CFStringRef)[sender representedObject],
//																					   NULL,
//																					   NULL);
//			// Undoc preference values
//			CFArrayRef connectionOptionList = CFPreferencesCopyValue((CFStringRef)[sender representedObject],
//																	 kAppleNetworkConnectDefaultsDomain,
//																	 kCFPreferencesCurrentUser,
//																	 kCFPreferencesCurrentHost);
//			if (connection) {
//				if (connectionOptionList && CFArrayGetCount(connectionOptionList)) {
//					SCNetworkConnectionStart(connection, CFArrayGetValueAtIndex(connectionOptionList, 0), TRUE);
//				} else {
//					SCNetworkConnectionStart(connection, NULL, TRUE);
//				}
//			}
//			if (connection) CFRelease(connection);
//			if (connectionOptionList) CFRelease(connectionOptionList);
//		} else {
//			// Direct control for 10.2
//			[pppControl connectServiceID:[sender representedObject]];
//		}
//	}
//	
//} // pppConnect
//
//- (void)pppDisconnect:(id)sender {
//	
//	if ([sender representedObject]) {
//		if (isPantherOrLater) {
//			SCNetworkConnectionRef connection = SCNetworkConnectionCreateWithServiceID(
//																					   kCFAllocatorDefault,
//																					   (CFStringRef)[sender representedObject],
//																					   NULL,
//																					   NULL);
//			if (connection) {
//				SCNetworkConnectionStop(connection, TRUE);
//				CFRelease(connection);
//			}
//		} else {
//			// Direct control for 10.2
//			[pppControl disconnectServiceID:[sender representedObject]];
//		}
//	}
//	
//} // pppDisconnect

- (IBAction)quit:(id)sender {
	NSRunInformationalAlertPanel(@"How to quit iPhoneLikeIndicator", @"This is the iPhoneLikeIndicator helper app. Go to the iPhoneLikeIndicator main application via your Dock and uncheck 'Start automatically at login (iPhoneLikeIndicator shows no dock icon when run in background that way)'", @"OK", nil, nil);
}

@end