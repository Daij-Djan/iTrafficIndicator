//
//  AppController.m
//  Autorunner
//
//  Created by Dominik Pich on 3/15/11.
//  Copyright 2011 FHK Gummersbach. All rights reserved.
//

#import "AppController.h"
#import <ServiceManagement/SMLoginItem.h>
#import "NSWindow+localize.h"
#import "M42PinchableWebView.h"
#import "NSUserDefaults+AR.h"

#define AboutControllerTextSizeMultiplier @"AboutControllerTextSizeMultiplier"

#define AppControllerEnabled @"AppControllerEnabled"
#define AppControllerAlreadyLaunched @"AppControllerAlreadyLaunched"

@implementation AppController

- (NSBundle*)getRegisteredHelper {
	NSString *childBundlePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Contents/Library/LoginItems/iTrafficIndicatorHelper.app"];
	NSBundle *childBundle = [NSBundle bundleWithPath:childBundlePath];
	if(LSRegisterURL((CFURLRef)[childBundle bundleURL], YES) != noErr) {
		NSLog(@"Failed to register helper");
	}
	
	return childBundle;
}

#pragma mark window

- (void)windowDidLoad {
	NSInteger i = [[NSUserDefaults arUserDefaults] integerForKey:MinBytesPrefKey];
	[textfield setStringValue:[NSString stringWithFormat:@"%d", i]];
	
	BOOL run = [[NSUserDefaults arUserDefaults] boolForKey:AppControllerEnabled];
	[checkbox setState:run ? NSOnState : NSOffState];
	NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"Html"];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
	[[webview mainFrame] loadRequest:request];
	[window localize];
	
}

- (IBAction)showWindow:(id)sender {	
	if([webview respondsToSelector:@selector(setTextSizeMultiplier:)])
	{
		CGFloat f = [[NSUserDefaults arUserDefaults] floatForKey:AboutControllerTextSizeMultiplier];
		if(f < 0.1) f = 1;
		[(id)webview setTextSizeMultiplier:f];
	}

	[window makeKeyAndOrderFront:sender];
	if(!alreadyDone) {
		alreadyDone = YES;
		[self windowDidLoad];
	}
	
	for (NSView *view in [[window contentView] subviews]) {
		if([view isKindOfClass:[NSTabView class]]) {
			[(NSTabView*)view selectTabViewItemAtIndex:0];
		}
	}
}

- (void)windowWillClose:(NSNotification *)notification {
	if([webview respondsToSelector:@selector(textSizeMultiplier)])
	{
		CGFloat f = [(id)webview textSizeMultiplier];
		if(!f) f = 1;
		if(f < 0.1) f = 1;
		[[NSUserDefaults arUserDefaults] setFloat:f forKey:AboutControllerTextSizeMultiplier];
	}
}

#pragma mark preferences

- (IBAction)toggleRunAtLogin:(id)sender {
	BOOL orun = [[NSUserDefaults arUserDefaults] boolForKey:AppControllerEnabled];
	BOOL run = !orun; //toggle
	
	//done on quit.. force quitting is bad ;)
//	NSBundle *childBundle = [self getRegisteredHelper];	
//	SMLoginItemSetEnabled((CFStringRef)[childBundle bundleIdentifier], run);
	
	[[NSUserDefaults arUserDefaults] setBool:run forKey:AppControllerEnabled];
}

#pragma mark application
- (void)applicationDidFinishLaunching:(NSNotification *)notification {
	NSNumber *pi = [[NSUserDefaults arUserDefaults] objectForKey:MinBytesPrefKey];
	if(!pi) {
		pi = [NSNumber numberWithInteger:750];
		[[NSUserDefaults arUserDefaults] setObject:pi forKey:MinBytesPrefKey];
	}
	
	[NSBundle loadNibNamed:@"MainMenu" owner:self];
	NSBundle *childBundle = [self getRegisteredHelper];
	
	if(![[NSUserDefaults arUserDefaults] boolForKey:AppControllerAlreadyLaunched]) {
		[[NSUserDefaults arUserDefaults] setBool:YES forKey:AppControllerAlreadyLaunched];
		[[NSUserDefaults arUserDefaults] setBool:NO forKey:AppControllerEnabled];		
	}
	SMLoginItemSetEnabled((CFStringRef)[childBundle bundleIdentifier], NO);
	SMLoginItemSetEnabled((CFStringRef)[childBundle bundleIdentifier], YES);			
	
	[self showWindow:nil];
}

- (void)applicationWillTerminate:(NSNotification *)notification {
	BOOL run = [[NSUserDefaults arUserDefaults] boolForKey:AppControllerEnabled];
	if(!run) {
		NSString *message = NSLocalizedString( @"continueInBG", @"bg");
		NSString *information = NSLocalizedString( @"continueInBGInfo", @"bg" );
		NSAlert *alert = [NSAlert alertWithMessageText:message defaultButton:@"Yes" alternateButton:@"No" otherButton:nil informativeTextWithFormat:information];
		[alert setAlertStyle:NSWarningAlertStyle];
		int result = [alert runModal];
		if( result == NSAlertDefaultReturn )
		{
			[[NSUserDefaults arUserDefaults] setBool:YES forKey:AppControllerEnabled];
			return;
		}
		
		NSBundle *childBundle = [self getRegisteredHelper];
		SMLoginItemSetEnabled((CFStringRef)[childBundle bundleIdentifier], NO);			
	}
}

-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
	return YES;
}

- (IBAction)updateMinBytes:(id)sender {
	NSInteger i = [[textfield stringValue] integerValue];
	[[NSUserDefaults arUserDefaults] setInteger:i forKey:MinBytesPrefKey];
	
	//restart the helper 
	NSBundle *childBundle = [self getRegisteredHelper];
	SMLoginItemSetEnabled((CFStringRef)[childBundle bundleIdentifier], NO);
	SMLoginItemSetEnabled((CFStringRef)[childBundle bundleIdentifier], YES);			
}

@end
