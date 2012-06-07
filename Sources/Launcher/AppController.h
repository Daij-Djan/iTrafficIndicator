//
//  ARAppController.h
//  Autorunner
//
//  Created by Dominik Pich on 3/15/11.
//  Copyright 2011 FHK Gummersbach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface AppController : NSObject<NSApplicationDelegate, NSWindowDelegate, NSTextDelegate> {
	BOOL alreadyDone;
	IBOutlet NSButton *checkbox;
	IBOutlet NSWindow *window;
	IBOutlet WebView *webview;
	IBOutlet NSTextField *textfield;
}
- (IBAction)toggleRunAtLogin:(id)sender;
- (IBAction)updateMinBytes:(id)sender;
@end
