//
//  AppController+MenuMeterMenu.m
//  iPhoneLikeIndicator
//
//  Created by Dominik Pich on 4/9/11.
//  Copyright 2011 FHK Gummersbach. All rights reserved.
//

#import "HelperAppController+MenuMeterMenu.h"
#import "MenuMeterLiveMenuWorkarounds.h"
#import "MenuMeterNet.h"
#import "MenuMeterNetConfig.h"

///////////////////////////////////////////////////////////////
//	
//	String formats
//
///////////////////////////////////////////////////////////////

#define kMenuIndentFormat				@"    %@"
#define kMenuDoubleIndentFormat			@"        %@"
#define kMenuTripleIndentFormat			@"            %@"

@implementation HelperAppController (MenuMeterMenu)

///////////////////////////////////////////////////////////////
//
//	Data formatting
//
///////////////////////////////////////////////////////////////

- (NSString *)throughputStringForBPS:(double)bps {
	
//	if ((bps < 1024) && [ourPrefs netThroughput1KBound]) {
//		bps = 0;
//	}
	if (bps > 1073741824) {
		return [NSString stringWithFormat:@"%@%@",
				[bytesFormatter stringForObjectValue:[NSNumber numberWithDouble:(double)bps / 1073741824]],
				[localizedStrings objectForKey:kGBPerSecondLabel]];
	} else if (bps > 1048576) {
		return [NSString stringWithFormat:@"%@%@",
				[bytesFormatter stringForObjectValue:[NSNumber numberWithDouble:(double)bps / 1048576]],
				[localizedStrings objectForKey:kMBPerSecondLabel]];
	} else if ((bps > 1024)) {// || [ourPrefs netThroughput1KBound]) {
		return [NSString stringWithFormat:@"%@%@",
				[bytesFormatter stringForObjectValue:[NSNumber numberWithDouble:(double)bps / 1024]],
				[localizedStrings objectForKey:kKBPerSecondLabel]];
	} else {
		return [NSString stringWithFormat:@"%.0f%@", (float)bps,
				[localizedStrings objectForKey:kBytePerSecondLabel]];
	}
	
} // throughputStringForBPS

- (NSString *)throughputStringForBytes:(double)bytes inInterval:(NSTimeInterval)interval {
	
	if (interval <= 0) return nil;
	return [self throughputStringForBPS:bytes / interval];
	
} // throughputStringForBytes:inInterval:

- (NSString *)menubarThroughputStringForBytes:(double)bytes inInterval:(NSTimeInterval)interval {
	
	double bps = bytes / interval;
//	if ((bps < 1024) && [ourPrefs netThroughput1KBound]) {
//		bps = 0;
//	}
	if (bps > 1073741824) {
		return [NSString stringWithFormat:@"%@%@",
				[bytesFormatter stringForObjectValue:[NSNumber numberWithDouble:(double)bps / 1073741824]],
				[localizedStrings objectForKey:kGBPerSecondLabel]];
	} else if (bps > 104857600) {
		// Patch from Alex Eddy, don't show decimals to limit to 4 digits
		return [NSString stringWithFormat:@"%.0f%@", bps / 1048576,
				[localizedStrings objectForKey:kMBPerSecondLabel]];
	} else if (bps > 1048576) {
		return [NSString stringWithFormat:@"%@%@",
				[bytesFormatter stringForObjectValue:[NSNumber numberWithDouble:(double)bps / 1048576]],
				[localizedStrings objectForKey:kMBPerSecondLabel]];
	} else if (bps > 102400) {
		// Patch from Alex Eddy, don't show decimals to limit to 4 digits
		return [NSString stringWithFormat:@"%.0f%@", bps / 1024,
				[localizedStrings objectForKey:kKBPerSecondLabel]];
	} else if ((bps > 1024)) {// || [ourPrefs netThroughput1KBound]) {
		return [NSString stringWithFormat:@"%@%@",
				[bytesFormatter stringForObjectValue:[NSNumber numberWithDouble:(double)bps / 1024]],
				[localizedStrings objectForKey:kKBPerSecondLabel]];
	} else {
		return [NSString stringWithFormat:@"%.0f%@", (float)bps,
				[localizedStrings objectForKey:kBytePerSecondLabel]];
	}
	
} // menubarThroughputStringForBytes:inInterval:

- (NSString *)stringForBytes:(double)bytes {
	
	if (bytes > 1073741824) {
		return [NSString stringWithFormat:@"%@%@",
				[bytesFormatter stringForObjectValue:[NSNumber numberWithDouble:bytes / 1073741824]],
				[localizedStrings objectForKey:kGBLabel]];
	} else if (bytes > 1048576) {
		return [NSString stringWithFormat:@"%@%@",
				[bytesFormatter stringForObjectValue:[NSNumber numberWithDouble:bytes / 1048576]],
				[localizedStrings objectForKey:kMBLabel]];
	} else if ((bytes > 1024)) {// || [ourPrefs netThroughput1KBound]) {
		return [NSString stringWithFormat:@"%@%@",
				[bytesFormatter stringForObjectValue:[NSNumber numberWithDouble:bytes / 1024]],
				[localizedStrings objectForKey:kKBLabel]];
	} else {
		return [NSString stringWithFormat:@"%.0f%@", bytes,
				[localizedStrings objectForKey:kByteLabel]];
	}
	
} // stringForBytes

#pragma mark public

- (void)prepareLocalizedData {
	// Localizable strings
	localizedStrings = [[NSDictionary dictionaryWithObjectsAndKeys:
						 [[NSBundle bundleForClass:[self class]] localizedStringForKey:kTxLabel value:nil table:nil],
						 kTxLabel,
						 [[NSBundle bundleForClass:[self class]] localizedStringForKey:kRxLabel value:nil table:nil],
						 kRxLabel,
						 [[NSBundle bundleForClass:[self class]] localizedStringForKey:kPPPTitle value:nil table:nil],
						 kPPPTitle,
						 [[NSBundle bundleForClass:[self class]] localizedStringForKey:kTCPIPTitle value:nil table:nil],
						 kTCPIPTitle,
						 [[NSBundle bundleForClass:[self class]] localizedStringForKey:kIPv4Title value:nil table:nil],
						 kIPv4Title,
						 [[NSBundle bundleForClass:[self class]] localizedStringForKey:kIPv6Title value:nil table:nil],
						 kIPv6Title,
						 [[NSBundle bundleForClass:[self class]] localizedStringForKey:kTCPIPInactiveTitle value:nil table:nil],
						 kTCPIPInactiveTitle,
						 [[NSBundle bundleForClass:[self class]] localizedStringForKey:kAppleTalkTitle value:nil table:nil],
						 kAppleTalkTitle,
						 [[NSBundle bundleForClass:[self class]] localizedStringForKey:kAppleTalkFormat value:nil table:nil],
						 kAppleTalkFormat,
						 [[NSBundle bundleForClass:[self class]] localizedStringForKey:kThroughputTitle value:nil table:nil],
						 kThroughputTitle,
						 [[NSBundle bundleForClass:[self class]] localizedStringForKey:kPeakThroughputTitle value:nil table:nil],
						 kPeakThroughputTitle,
						 [[NSBundle bundleForClass:[self class]] localizedStringForKey:kTrafficTotalTitle value:nil table:nil],
						 kTrafficTotalTitle,
						 [[NSBundle bundleForClass:[self class]] localizedStringForKey:kTrafficTotalFormat value:nil table:nil],
						 kTrafficTotalFormat,
						 [[NSBundle bundleForClass:[self class]] localizedStringForKey:kOpenNetworkUtilityTitle value:nil table:nil],
						 kOpenNetworkUtilityTitle,
						 [[NSBundle bundleForClass:[self class]] localizedStringForKey:kOpenNetworkPrefsTitle value:nil table:nil],
						 kOpenNetworkPrefsTitle,
						 [[NSBundle bundleForClass:[self class]] localizedStringForKey:kOpenInternetConnectTitle value:nil table:nil],
						 kOpenInternetConnectTitle,
						 [[NSBundle bundleForClass:[self class]] localizedStringForKey:kNoInterfaceErrorMessage value:nil table:nil],
						 kNoInterfaceErrorMessage,
						 [[NSBundle bundleForClass:[self class]] localizedStringForKey:kSelectPrimaryInterfaceTitle value:nil table:nil],
						 kSelectPrimaryInterfaceTitle,
						 [[NSBundle bundleForClass:[self class]] localizedStringForKey:kSelectInterfaceTitle value:nil table:nil],
						 kSelectInterfaceTitle,
						 [[NSBundle bundleForClass:[self class]] localizedStringForKey:kCopyIPv4Title value:nil table:nil],
						 kCopyIPv4Title,
						 [[NSBundle bundleForClass:[self class]] localizedStringForKey:kCopyIPv6Title value:nil table:nil],
						 kCopyIPv6Title,
						 [[NSBundle bundleForClass:[self class]] localizedStringForKey:kPPPConnectTitle value:nil table:nil],
						 kPPPConnectTitle,
						 [[NSBundle bundleForClass:[self class]] localizedStringForKey:kPPPDisconnectTitle value:nil table:nil],
						 kPPPDisconnectTitle,
						 [[NSBundle bundleForClass:[self class]] localizedStringForKey:kGbpsLabel value:nil table:nil],
						 kGbpsLabel,
						 [[NSBundle bundleForClass:[self class]] localizedStringForKey:kMbpsLabel value:nil table:nil],
						 kMbpsLabel,
						 [[NSBundle bundleForClass:[self class]] localizedStringForKey:kKbpsLabel value:nil table:nil],
						 kKbpsLabel,
						 [[NSBundle bundleForClass:[self class]] localizedStringForKey:kByteLabel value:nil table:nil],
						 kByteLabel,
						 [[NSBundle bundleForClass:[self class]] localizedStringForKey:kKBLabel value:nil table:nil],
						 kKBLabel,
						 [[NSBundle bundleForClass:[self class]] localizedStringForKey:kMBLabel value:nil table:nil],
						 kMBLabel,
						 [[NSBundle bundleForClass:[self class]] localizedStringForKey:kGBLabel value:nil table:nil],
						 kGBLabel,
						 [[NSBundle bundleForClass:[self class]] localizedStringForKey:kBytePerSecondLabel value:nil table:nil],
						 kBytePerSecondLabel,
						 [[NSBundle bundleForClass:[self class]] localizedStringForKey:kKBPerSecondLabel value:nil table:nil],
						 kKBPerSecondLabel,
						 [[NSBundle bundleForClass:[self class]] localizedStringForKey:kMBPerSecondLabel value:nil table:nil],
						 kMBPerSecondLabel,
						 [[NSBundle bundleForClass:[self class]] localizedStringForKey:kGBPerSecondLabel value:nil table:nil],
						 kGBPerSecondLabel,
						 [[NSBundle bundleForClass:[self class]] localizedStringForKey:kPPPNoConnectTitle value:nil table:nil],
						 kPPPNoConnectTitle,
						 [[NSBundle bundleForClass:[self class]] localizedStringForKey:kPPPConnectingTitle value:nil table:nil],
						 kPPPConnectingTitle,
						 [[NSBundle bundleForClass:[self class]] localizedStringForKey:kPPPConnectedTitle value:nil table:nil],
						 kPPPConnectedTitle,
						 [[NSBundle bundleForClass:[self class]] localizedStringForKey:kPPPConnectedWithTimeTitle value:nil table:nil],
						 kPPPConnectedWithTimeTitle,
						 [[NSBundle bundleForClass:[self class]] localizedStringForKey:kPPPDisconnectingTitle value:nil table:nil],
						 kPPPDisconnectingTitle,
						 nil] retain];
	
	// Set up a NumberFormatter for localization. This is based on code contributed by Mike Fischer
	// (mike.fischer at fi-works.de) for use in MenuMeters.
	NSNumberFormatter *tempFormat = [[[NSNumberFormatter alloc] init] autorelease];
	[tempFormat setLocalizesFormat:YES];
	[tempFormat setFormat:@"###0.0"];
	// Go through an archive/unarchive cycle to work around a bug on pre-10.2.2 systems
	// see http://cocoa.mamasam.com/COCOADEV/2001/12/2/21029.php
	bytesFormatter = [[NSUnarchiver unarchiveObjectWithData:[NSArchiver archivedDataWithRootObject:tempFormat]] retain];
	tempFormat = [[[NSNumberFormatter alloc] init] autorelease];
	[tempFormat setLocalizesFormat:YES];
	[tempFormat setFormat:@"#,##0"];
	prettyIntFormatter = [[NSUnarchiver unarchiveObjectWithData:[NSArchiver archivedDataWithRootObject:tempFormat]] retain];
}

// Boy does this need refactoring... *sigh*
- (NSMenu *)menu {
	
	// New cache
	[updateMenuItems release];
	updateMenuItems = [[NSMutableDictionary dictionary] retain];//
	
	// Empty the menu
	while ([extraMenu numberOfItems]) {
		[extraMenu removeItemAtIndex:0];
	}
	
	// Hostname
	NSString *hostname = [[netConfig computerName] retain];
	if (hostname) {
		[[extraMenu addItemWithTitle:hostname action:nil keyEquivalent:@""] setEnabled:NO];
		[extraMenu addItem:[NSMenuItem separatorItem]];
	}
	
	// Interface detail array
	BOOL pppPresent = NO;
	NSArray *interfaceDetails = [netConfig interfaceDetails];
	if ([interfaceDetails count]) {
		NSEnumerator *detailEnum = [interfaceDetails objectEnumerator];
		NSDictionary *details = nil;
		while ((details = [detailEnum nextObject])) {
			// Array entry is a service/interface
			NSMutableDictionary *interfaceUpdateMenuItems = [NSMutableDictionary dictionary];
			NSString *interfaceDescription = [details objectForKey:@"name"];
			NSString *speed = nil;
//			BOOL foundSelectedInterface = NO;
			// Best guess if this is an active interface, default to assume it is active
			BOOL isActiveInterface = YES;
			if ([details objectForKey:@"linkactive"]) {
				isActiveInterface = [[details objectForKey:@"linkactive"] boolValue];
			}
			if ([details objectForKey:@"pppstatus"]) {
				if ([(NSNumber *)[[details objectForKey:@"pppstatus"] objectForKey:@"status"] unsignedIntValue] == PPP_IDLE) {
					isActiveInterface = NO;
				}
			}
			// Calc speed
			if ([details objectForKey:@"linkspeed"] && isActiveInterface) {
				if ([[details objectForKey:@"linkspeed"] doubleValue] > 1000000000) {
					speed = [NSString stringWithFormat:@" %.0f%@",
							 ([[details objectForKey:@"linkspeed"] doubleValue] / 1000000000),
							 [localizedStrings objectForKey:kGbpsLabel]];
				} else if ([[details objectForKey:@"linkspeed"] doubleValue] > 1000000) {
					speed = [NSString stringWithFormat:@" %.0f%@",
							 ([[details objectForKey:@"linkspeed"] doubleValue] / 1000000),
							 [localizedStrings objectForKey:kMbpsLabel]];
				} else {
					speed = [NSString stringWithFormat:@" %@%@",
							 [bytesFormatter stringForObjectValue:
							  [NSNumber numberWithDouble:([[details objectForKey:@"linkspeed"] doubleValue] / 1000)]],
							 [localizedStrings objectForKey:kKbpsLabel]];
				}
			}
			// Weird string cat because some of these values may not be present
			// Also skip device name bit if the driver name (UserDefined name) already includes it (SourceForge wireless driver)
			if ([details objectForKey:@"devicename"] &&
				![interfaceDescription hasSuffix:[NSString stringWithFormat:@"(%@)", [details objectForKey:@"devicename"]]]) {
				// If there is a PPP name use it too
				if ([details objectForKey:@"devicepppname"]) {
					interfaceDescription = [NSString stringWithFormat:@"%@ (%@, %@)",
											interfaceDescription,
											[details objectForKey:@"devicename"],
											[details objectForKey:@"devicepppname"]];
				} else {
					interfaceDescription = [NSString stringWithFormat:@"%@ (%@)",
											interfaceDescription,
											[details objectForKey:@"devicename"]];
				}
			}
			if (speed || [details objectForKey:@"connectiontype"]) {
				interfaceDescription = [NSString stringWithFormat:@"%@ -%@%@",
										interfaceDescription,
										([details objectForKey:@"connectiontype"] ?
										 [NSString stringWithFormat:@" %@", [details objectForKey:@"connectiontype"]] : @""),
										(speed ? speed : @"")];
			}
			NSMenuItem *titleItem = (NSMenuItem *)[extraMenu addItemWithTitle:interfaceDescription action:nil keyEquivalent:@""];
			// PPP Status
			if ([details objectForKey:@"pppstatus"]) {
				// PPP is present
				pppPresent = YES;
				NSMenuItem *pppStatusItem = nil;
				// Use the connection type title for PPP when we can
				if ([details objectForKey:@"connectiontype"]) {
					[[extraMenu addItemWithTitle:[NSString stringWithFormat:kMenuIndentFormat,
												  [NSString stringWithFormat:@"%@:", [details objectForKey:@"connectiontype"]]]
										  action:nil
								   keyEquivalent:@""] setEnabled:NO];
				} else {
					[[extraMenu addItemWithTitle:[NSString stringWithFormat:kMenuIndentFormat, [localizedStrings objectForKey:kPPPTitle]]
										  action:nil
								   keyEquivalent:@""] setEnabled:NO];
				}
				switch ([(NSNumber *)[[details objectForKey:@"pppstatus"] objectForKey:@"status"] unsignedIntValue]) {
					case PPP_IDLE:
						pppStatusItem = (NSMenuItem *)[extraMenu addItemWithTitle:[NSString stringWithFormat:kMenuDoubleIndentFormat,
																				   [localizedStrings objectForKey:kPPPNoConnectTitle]]
																		   action:nil
																	keyEquivalent:@""];
						break;
					case PPP_INITIALIZE:
					case PPP_CONNECTLINK:
					case PPP_STATERESERVED:
					case PPP_ESTABLISH:
					case PPP_AUTHENTICATE:
					case PPP_CALLBACK:
					case PPP_NETWORK:
					case PPP_HOLDOFF:
					case PPP_ONHOLD:
					case PPP_WAITONBUSY:
						pppStatusItem = (NSMenuItem *)[extraMenu addItemWithTitle:[NSString stringWithFormat:kMenuDoubleIndentFormat,
																				   [localizedStrings objectForKey:kPPPConnectingTitle]]
																		   action:nil
																	keyEquivalent:@""];
						break;
					case PPP_RUNNING:
						if ([[details objectForKey:@"pppstatus"] objectForKey:@"timeElapsed"]) {
							uint32_t secs = [[[details objectForKey:@"pppstatus"] objectForKey:@"timeElapsed"] unsignedIntValue];
							uint32_t hours = secs / (60 * 60);
							secs %= (60 * 60);
							uint32_t mins = secs / 60;
							secs %= 60;
							pppStatusItem = (NSMenuItem *)[extraMenu addItemWithTitle:[NSString stringWithFormat:kMenuDoubleIndentFormat,
																					   [NSString stringWithFormat:
																						[localizedStrings objectForKey:kPPPConnectedWithTimeTitle],
																						hours, mins, secs]]
																			   action:nil
																		keyEquivalent:@""];
						} else {
							pppStatusItem = (NSMenuItem *)[extraMenu addItemWithTitle:[NSString stringWithFormat:kMenuDoubleIndentFormat, kPPPConnectedTitle]
																			   action:nil
																		keyEquivalent:@""];
						}
						break;
					case PPP_TERMINATE:
					case PPP_DISCONNECTLINK:
						pppStatusItem = (NSMenuItem *)[extraMenu addItemWithTitle:[NSString stringWithFormat:kMenuIndentFormat,
																				   [localizedStrings objectForKey:kPPPDisconnectingTitle]]
																		   action:nil
																	keyEquivalent:@""];
						break;
				};
				if (pppStatusItem) {
					[pppStatusItem setEnabled:NO];
					[interfaceUpdateMenuItems setObject:pppStatusItem forKey:@"pppstatusitem"];
				}
			}
			// TCP/IP
			[[extraMenu addItemWithTitle:[NSString stringWithFormat:kMenuIndentFormat, [localizedStrings objectForKey:kTCPIPTitle]]
								  action:nil
						   keyEquivalent:@""] setEnabled:NO];
			if ([[details objectForKey:@"ipv4addresses"] count] && [[details objectForKey:@"ipv6addresses"] count]) {
				[[extraMenu addItemWithTitle:[NSString stringWithFormat:kMenuDoubleIndentFormat, [localizedStrings objectForKey:kIPv4Title]]
									  action:nil
							   keyEquivalent:@""] setEnabled:NO];
				NSEnumerator *addressEnum = [[details objectForKey:@"ipv4addresses"] objectEnumerator];
				NSString *address = nil;
				while ((address = [addressEnum nextObject])) {
					[[extraMenu addItemWithTitle:[NSString stringWithFormat:kMenuTripleIndentFormat, address]
										  action:nil
								   keyEquivalent:@""] setEnabled:NO];
				}
				[[extraMenu addItemWithTitle:[NSString stringWithFormat:kMenuDoubleIndentFormat, [localizedStrings objectForKey:kIPv6Title]]
									  action:nil
							   keyEquivalent:@""] setEnabled:NO];
				addressEnum = [[details objectForKey:@"ipv6addresses"] objectEnumerator];
				while ((address = [addressEnum nextObject])) {
					[[extraMenu addItemWithTitle:[NSString stringWithFormat:kMenuTripleIndentFormat, address]
										  action:nil
								   keyEquivalent:@""] setEnabled:NO];
				}
			} else if ([[details objectForKey:@"ipv4addresses"] count]) {
				NSEnumerator *addressEnum = [[details objectForKey:@"ipv4addresses"] objectEnumerator];
				NSString *address = nil;
				while ((address = [addressEnum nextObject])) {
					[[extraMenu addItemWithTitle:[NSString stringWithFormat:kMenuDoubleIndentFormat, address]
										  action:nil
								   keyEquivalent:@""] setEnabled:NO];
				}
			} else {
				[[extraMenu addItemWithTitle:[NSString stringWithFormat:kMenuDoubleIndentFormat,
											  [localizedStrings objectForKey:kTCPIPInactiveTitle]]
									  action:nil
							   keyEquivalent:@""] setEnabled:NO];
			}
			// AppleTalk
			if ([details objectForKey:@"appletalknetid"]) {
				[[extraMenu addItemWithTitle:[NSString stringWithFormat:kMenuIndentFormat,
											  [localizedStrings objectForKey:kAppleTalkTitle]]
									  action:nil
							   keyEquivalent:@""] setEnabled:NO];
				[[extraMenu addItemWithTitle:[NSString stringWithFormat:kMenuDoubleIndentFormat,
											  [NSString stringWithFormat:[localizedStrings objectForKey:kAppleTalkFormat],
											   [details objectForKey:@"appletalknetid"],
											   [details objectForKey:@"appletalknodeid"],
											   [details objectForKey:@"appletalkzone"]]]
									  action:nil
							   keyEquivalent:@""] setEnabled:NO];
			}
			// Throughput
			NSNumber *sampleIntervalNum = lastNetInterval;
			NSDictionary *throughputDetails = nil;
			NSString *throughputInterface = nil;
			// Do some dancing to make sure to get serial and VPN PPP interfaces, but not PPPoE
			if (lastNetData && ([details objectForKey:@"devicename"] || [details objectForKey:@"devicepppname"])) {
				if ([details objectForKey:@"devicepppname"] && ![[details objectForKey:@"devicename"] hasPrefix:@"en"]) {
					throughputInterface = [details objectForKey:@"devicepppname"];
					throughputDetails = [lastNetData objectForKey:[details objectForKey:@"devicepppname"]];
				} else {
					throughputInterface = [details objectForKey:@"devicename"];
					throughputDetails = [lastNetData objectForKey:[details objectForKey:@"devicename"]];
				}
			}
			// Do we have throughput info on an active interface?
			if (isActiveInterface && sampleIntervalNum && throughputInterface && throughputDetails) {
				NSNumber *throughputOutNumber = [throughputDetails objectForKey:@"deltaout"];
				NSNumber *throughputInNumber = [throughputDetails objectForKey:@"deltain"];
				if (throughputOutNumber && throughputInNumber) {
					[[extraMenu addItemWithTitle:[NSString stringWithFormat:kMenuIndentFormat, [localizedStrings objectForKey:kThroughputTitle]]
										  action:nil
								   keyEquivalent:@""] setEnabled:NO];
					NSMenuItem *throughputItem = (NSMenuItem *)[extraMenu addItemWithTitle:[NSString stringWithFormat:kMenuDoubleIndentFormat,
																							[NSString stringWithFormat:@"%@ %@",
																							 [localizedStrings objectForKey:kTxLabel],
																							 [self throughputStringForBytes:[throughputOutNumber doubleValue]
																												 inInterval:[sampleIntervalNum doubleValue]]]]
																					action:nil
																			 keyEquivalent:@""];
					[throughputItem setEnabled:NO];
					[interfaceUpdateMenuItems setObject:throughputItem forKey:@"deltaoutitem"];
					throughputItem = (NSMenuItem *)[extraMenu addItemWithTitle:[NSString stringWithFormat:kMenuDoubleIndentFormat,
																				[NSString stringWithFormat:@"%@ %@",
																				 [localizedStrings objectForKey:kRxLabel],
																				 [self throughputStringForBytes:[throughputInNumber doubleValue]
																									 inInterval:[sampleIntervalNum doubleValue]]]]
																		action:nil
																 keyEquivalent:@""];
					[throughputItem setEnabled:NO];
					[interfaceUpdateMenuItems setObject:throughputItem forKey:@"deltainitem"];
				}
				// Add peak throughput
				NSNumber *peakNumber = [throughputDetails objectForKey:@"peak"];
				if (peakNumber) {
					[[extraMenu addItemWithTitle:[NSString stringWithFormat:kMenuIndentFormat, [localizedStrings objectForKey:kPeakThroughputTitle]]
										  action:nil
								   keyEquivalent:@""] setEnabled:NO];
					NSMenuItem *peakItem = (NSMenuItem *)[extraMenu addItemWithTitle:[NSString stringWithFormat:kMenuDoubleIndentFormat,
																					  [self throughputStringForBPS:[peakNumber doubleValue]]]
																			  action:nil
																	   keyEquivalent:@""];
					[peakItem setEnabled:NO];
					[interfaceUpdateMenuItems setObject:peakItem forKey:@"peakitem"];
				}
				// Add traffic totals
				throughputOutNumber = [throughputDetails objectForKey:@"totalout"];
				throughputInNumber = [throughputDetails objectForKey:@"totalin"];
				if (throughputOutNumber && throughputInNumber) {
					[[extraMenu addItemWithTitle:[NSString stringWithFormat:kMenuIndentFormat, [localizedStrings objectForKey:kTrafficTotalTitle]]
										  action:nil
								   keyEquivalent:@""] setEnabled:NO];
					NSMenuItem *totalItem = (NSMenuItem *)[extraMenu addItemWithTitle:[NSString stringWithFormat:kMenuDoubleIndentFormat,
																					   [NSString stringWithFormat:[localizedStrings objectForKey:kTrafficTotalFormat],
																						[localizedStrings objectForKey:kTxLabel],
																						[self stringForBytes:[throughputOutNumber doubleValue]],
																						[prettyIntFormatter stringForObjectValue:throughputOutNumber]]]
																			   action:nil
																		keyEquivalent:@""];
					[totalItem setEnabled:NO];
					[interfaceUpdateMenuItems setObject:totalItem forKey:@"totaloutitem"];
					totalItem = (NSMenuItem *)[extraMenu addItemWithTitle:[NSString stringWithFormat:kMenuDoubleIndentFormat,
																		   [NSString stringWithFormat:[localizedStrings objectForKey:kTrafficTotalFormat],
																			[localizedStrings objectForKey:kRxLabel],
																			[self stringForBytes:[throughputInNumber doubleValue]],
																			[prettyIntFormatter stringForObjectValue:throughputInNumber]]]
																   action:nil
															keyEquivalent:@""];
					[totalItem setEnabled:NO];
					[interfaceUpdateMenuItems setObject:totalItem forKey:@"totalinitem"];
				}
				// Store the name to use in throughput reads for items we will update later
				[interfaceUpdateMenuItems setObject:throughputInterface forKey:@"throughinterface"];
			}
			
			// Store the update items we built for this interface if needed
			if ([interfaceUpdateMenuItems count]) {
				[updateMenuItems setObject:interfaceUpdateMenuItems forKey:[details objectForKey:@"service"]];
			}
			
			// Now set up the submenu for this interface
			NSMenu *interfaceSubmenu = [[[NSMenu alloc] initWithTitle:@""] autorelease];
			// Disable menu autoenabling
			[interfaceSubmenu setAutoenablesItems:NO];
			// Add the submenu
			[titleItem setSubmenu:interfaceSubmenu];
//			// PPP controller if needed and we can control the connection type on this OS version
//			if ([details objectForKey:@"pppstatus"]) { //&& ([[details objectForKey:@"connectiontype"] isEqualToString:@"PPP"] || isPantherOrLater)) {
//				NSMenuItem *pppControlItem = nil;
//				switch ([(NSNumber *)[[details objectForKey:@"pppstatus"] objectForKey:@"status"] unsignedIntValue]) {
//					case PPP_IDLE:
//						pppControlItem = (NSMenuItem *)[interfaceSubmenu addItemWithTitle:[localizedStrings objectForKey:kPPPConnectTitle]
//																				   action:@selector(pppConnect:)
//																			keyEquivalent:@""];
//						break;
//					case PPP_INITIALIZE:
//					case PPP_CONNECTLINK:
//					case PPP_STATERESERVED:
//					case PPP_ESTABLISH:
//					case PPP_AUTHENTICATE:
//					case PPP_CALLBACK:
//					case PPP_NETWORK:
//					case PPP_HOLDOFF:
//					case PPP_ONHOLD:
//					case PPP_WAITONBUSY:
//					case PPP_RUNNING:
//						pppControlItem = (NSMenuItem *)[interfaceSubmenu addItemWithTitle:[localizedStrings objectForKey:kPPPDisconnectTitle]
//																				   action:@selector(pppDisconnect:)
//																			keyEquivalent:@""];
//						break;
//					case PPP_TERMINATE:
//					case PPP_DISCONNECTLINK:
//						pppControlItem = (NSMenuItem *)[interfaceSubmenu addItemWithTitle:[localizedStrings objectForKey:kPPPConnectTitle]
//																				   action:@selector(pppConnect:)
//																			keyEquivalent:@""];
//						break;
//				};
//				[pppControlItem setTarget:self];
//				[pppControlItem setRepresentedObject:[details objectForKey:@"service"]];
//				[interfaceSubmenu addItem:[NSMenuItem separatorItem]];
//			}

			// Copy IP
			NSMenuItem *copyIPItem = (NSMenuItem *)[interfaceSubmenu addItemWithTitle:[localizedStrings objectForKey:kCopyIPv4Title]
																			   action:@selector(copyAddress:)
																		keyEquivalent:@""];
			[copyIPItem setTarget:self];
			if ([[details objectForKey:@"ipv4addresses"] count]) {
				[copyIPItem setRepresentedObject:[details objectForKey:@"ipv4addresses"]];
			} else {
				[copyIPItem setEnabled:NO];
			}
			if ([[details objectForKey:@"ipv6addresses"] count]) {
				copyIPItem = (NSMenuItem *)[interfaceSubmenu addItemWithTitle:[localizedStrings objectForKey:kCopyIPv6Title]
																	   action:@selector(copyAddress:)
																keyEquivalent:@""];
				[copyIPItem setTarget:self];
				if ([[details objectForKey:@"ipv6addresses"] count]) {
					[copyIPItem setRepresentedObject:[details objectForKey:@"ipv6addresses"]];
				} else {
					[copyIPItem setEnabled:NO];
				}
			}
		}
	} else {
		[[extraMenu addItemWithTitle:[localizedStrings objectForKey:kNoInterfaceErrorMessage]
							  action:nil
					   keyEquivalent:@""] setEnabled:NO];
	}
	
	// Add utility items
	[extraMenu addItem:[NSMenuItem separatorItem]];
	[[extraMenu addItemWithTitle:[localizedStrings objectForKey:kOpenNetworkUtilityTitle]
						  action:@selector(openNetworkUtil:)
				   keyEquivalent:@""] setTarget:self];
	[[extraMenu addItemWithTitle:[localizedStrings objectForKey:kOpenNetworkPrefsTitle]
						  action:@selector(openNetworkPrefs:)
				   keyEquivalent:@""] setTarget:self];
	// Open Internet Connect if PPP
	if (pppPresent) {// && !isLeopardOrLater) {
		[[extraMenu addItemWithTitle:[localizedStrings objectForKey:kOpenInternetConnectTitle]
							  action:@selector(openInternetConnect:)
					   keyEquivalent:@""] setTarget:self];
	}
	
	// Send the menu back to SystemUIServer
	return extraMenu;
	
} // menu

- (void)updateMenuWhileDown {
	// If no menu items are currently live, do nothing
	if (!updateMenuItems) return;
	
	// Pull in latest data and iterate, updating existing menu items
	NSArray *detailsArray = [netConfig interfaceDetails];
	if (![detailsArray count]) return;
	NSEnumerator *detailsEnum = [detailsArray objectEnumerator];
	NSDictionary *details = nil;
	while ((details = [detailsEnum nextObject])) {
		// Do we have updates?
		if (![details objectForKey:@"service"] || ![updateMenuItems objectForKey:[details objectForKey:@"service"]]) {
			continue;
		}
		NSDictionary *updateInfoForService = [updateMenuItems objectForKey:[details objectForKey:@"service"]];
		
		
		// PPP updates
		if ([updateInfoForService objectForKey:@"pppstatusitem"]) {
			NSMenuItem *pppMenuItem = [updateInfoForService objectForKey:@"pppstatusitem"];
			switch ([(NSNumber *)[[details objectForKey:@"pppstatus"] objectForKey:@"status"] unsignedIntValue]) {
				case PPP_IDLE:
					LiveUpdateMenuItemTitle(extraMenu,
											[extraMenu indexOfItem:pppMenuItem],
											[NSString stringWithFormat:kMenuDoubleIndentFormat,
											 [localizedStrings objectForKey:kPPPNoConnectTitle]]);
					break;
				case PPP_INITIALIZE:
				case PPP_CONNECTLINK:
				case PPP_STATERESERVED:
				case PPP_ESTABLISH:
				case PPP_AUTHENTICATE:
				case PPP_CALLBACK:
				case PPP_NETWORK:
				case PPP_HOLDOFF:
				case PPP_ONHOLD:
				case PPP_WAITONBUSY:
					LiveUpdateMenuItemTitle(extraMenu,
											[extraMenu indexOfItem:pppMenuItem],
											[NSString stringWithFormat:kMenuDoubleIndentFormat,
											 [localizedStrings objectForKey:kPPPConnectingTitle]]);
					break;
				case PPP_RUNNING:
					if ([[details objectForKey:@"pppstatus"] objectForKey:@"timeElapsed"]) {
						uint32_t secs = [[[details objectForKey:@"pppstatus"] objectForKey:@"timeElapsed"] unsignedIntValue];
						uint32_t hours = secs / (60 * 60);
						secs %= (60 * 60);
						uint32_t mins = secs / 60;
						secs %= 60;
						LiveUpdateMenuItemTitle(extraMenu,
												[extraMenu indexOfItem:pppMenuItem],
												[NSString stringWithFormat:kMenuDoubleIndentFormat,
												 [NSString stringWithFormat:
												  [localizedStrings objectForKey:kPPPConnectedWithTimeTitle],
												  hours, mins, secs]]);
					} else {
						LiveUpdateMenuItemTitle(extraMenu,
												[extraMenu indexOfItem:pppMenuItem],
												[NSString stringWithFormat:kMenuDoubleIndentFormat, kPPPConnectedTitle]);
					}
					break;
					break;
				case PPP_TERMINATE:
				case PPP_DISCONNECTLINK:
					LiveUpdateMenuItemTitle(extraMenu,
											[extraMenu indexOfItem:pppMenuItem],
											[NSString stringWithFormat:kMenuDoubleIndentFormat,
											 [localizedStrings objectForKey:kPPPDisconnectingTitle]]);
			};
		}
		// Throughput updates
		if ([updateInfoForService objectForKey:@"throughinterface"]) {
			NSNumber *sampleIntervalNum = lastNetInterval;
			NSDictionary *throughputDetails = [lastNetData objectForKey:[updateInfoForService objectForKey:@"throughinterface"]];
			if (throughputDetails && sampleIntervalNum) {
				// Update for this interface
				NSMenuItem *targetItem = [updateInfoForService objectForKey:@"deltaoutitem"];
				NSNumber *throughputNumber = [throughputDetails objectForKey:@"deltaout"];
				if (targetItem && throughputNumber) {
					LiveUpdateMenuItemTitle(extraMenu,
											[extraMenu indexOfItem:targetItem],
											[NSString stringWithFormat:kMenuDoubleIndentFormat,
											 [NSString stringWithFormat:@"%@ %@",
											  [localizedStrings objectForKey:kTxLabel],
											  [self throughputStringForBytes:[throughputNumber doubleValue] inInterval:[sampleIntervalNum doubleValue]]]]);
				}
				targetItem = [updateInfoForService objectForKey:@"deltainitem"];
				throughputNumber = [throughputDetails objectForKey:@"deltain"];
				if (targetItem && throughputNumber) {
					LiveUpdateMenuItemTitle(extraMenu,
											[extraMenu indexOfItem:targetItem],
											[NSString stringWithFormat:kMenuDoubleIndentFormat,
											 [NSString stringWithFormat:@"%@ %@",
											  [localizedStrings objectForKey:kRxLabel],
											  [self throughputStringForBytes:[throughputNumber doubleValue] inInterval:[sampleIntervalNum doubleValue]]]]);
				}
				targetItem = [updateInfoForService objectForKey:@"totaloutitem"];
				throughputNumber = [throughputDetails objectForKey:@"totalout"];
				if (targetItem && throughputNumber) {
					LiveUpdateMenuItemTitle(extraMenu,
											[extraMenu indexOfItem:targetItem],
											[NSString stringWithFormat:kMenuDoubleIndentFormat,
											 [NSString stringWithFormat:[localizedStrings objectForKey:kTrafficTotalFormat],
											  [localizedStrings objectForKey:kTxLabel],
											  [self stringForBytes:[throughputNumber doubleValue]],
											  [prettyIntFormatter stringForObjectValue:throughputNumber]]]);
				}
				targetItem = [updateInfoForService objectForKey:@"totalinitem"];
				throughputNumber = [throughputDetails objectForKey:@"totalin"];
				if (targetItem && throughputNumber) {
					LiveUpdateMenuItemTitle(extraMenu,
											[extraMenu indexOfItem:targetItem],
											[NSString stringWithFormat:kMenuDoubleIndentFormat,
											 [NSString stringWithFormat:[localizedStrings objectForKey:kTrafficTotalFormat],
											  [localizedStrings objectForKey:kRxLabel],
											  [self stringForBytes:[throughputNumber doubleValue]],
											  [prettyIntFormatter stringForObjectValue:throughputNumber]]]);
				}
				targetItem = [updateInfoForService objectForKey:@"peakitem"];
				throughputNumber = [throughputDetails objectForKey:@"peak"];
				if (targetItem && throughputNumber) {
					LiveUpdateMenuItemTitle(extraMenu,
											[extraMenu indexOfItem:targetItem],
											[NSString stringWithFormat:kMenuDoubleIndentFormat,
											 [self throughputStringForBPS:[throughputNumber doubleValue]]]);
				}
			}
		}
	} // end details loop
	
	// Force the menu to redraw
	LiveUpdateMenu(extraMenu);
}

@end
