//
//  AppController.h
//  iPhoneLikeIndicator
//
//  Created by Dominik Pich on 12.09.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@class ProgressIndicator;
@class MenuMeterNetStats;
@class MenuMeterNetConfig;
@class MenuMeterNetPPP;

@interface HelperAppController : NSObject<NSApplicationDelegate> {
	ProgressIndicator *networkIndicator;
	NSStatusItem *statusItem;
	NSTimer *updateTimer;
	NSDate *lastSampleDate;
	MenuMeterNetStats *netStats;
	MenuMeterNetConfig *netConfig;
	MenuMeterNetPPP *pppControl;
	NSInteger minBytes;

	NSDictionary *lastNetData;
	NSNumber *lastNetInterval;
	
	NSMenu *extraMenu;
	NSMutableDictionary *updateMenuItems;
	
	NSDictionary *localizedStrings;
	NSNumberFormatter *bytesFormatter;
	NSNumberFormatter *prettyIntFormatter;
}

@end
