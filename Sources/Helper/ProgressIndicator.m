//
//  ProgressIndicator.m
//  iPhoneLikeIndicator
//
//  Created by Dominik Pich on 12.09.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ProgressIndicator.h"

@implementation ProgressIndicator

- (void)dealloc {
	[indicatorView removeFromSuperview];
	[indicatorView release];
	[super dealloc];
}

- (void)drawRect:(NSRect)rect {
	//center in statusbar
	if(!indicatorView) {
		float min = fmin([self frame].size.width, [self frame].size.height);
		min -= 4;
		float x = [self frame].size.width/2 - min/2;
		float y = [self frame].size.height/2 - min/2;
		indicatorView = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect(x, y, min, min)];
		[indicatorView setStyle:NSProgressIndicatorSpinningStyle];
		[self addSubview:indicatorView];
		
		[indicatorView setMenu:[self menu]];
	}
	
	[statusItem drawStatusBarBackgroundInRect:rect withHighlight:NO];
}


- (void)setMenu:(NSMenu*)menu {
	[super setMenu:menu];
	[indicatorView setMenu:menu];
}

- (void)setFrame:(NSRect)frame {
	[super setFrame:frame];

	float min = fmin(frame.size.width, frame.size.height);
	min -= 4;
	float x = frame.size.width/2 - min/2;
	float y = frame.size.height/2 - min/2;
	[indicatorView setFrame:NSMakeRect(x, y, min, min)];	
}

#pragma mark custom public interface

- (void)setStatusItem:(NSStatusItem*)item {
	statusItem = item;
}

- (void)startAnimating {
	if(isAnimating) return;
	isAnimating = YES;
	[indicatorView startAnimation:nil];
}

- (void)stopAnimating {
	if(!isAnimating) return;
	[indicatorView stopAnimation:nil];
	isAnimating = NO;
}

- (BOOL)isAnimating {
	return isAnimating;
}

#pragma mark menu

- (void)setMenuDown:(BOOL)flag {
	menuDown = flag;
}

- (BOOL)isMenuDown {
	return menuDown;
}

@end

@interface NSProgressIndicator (menu) <NSMenuDelegate>
@end

@implementation NSProgressIndicator (menu)

- (void)mouseUp:(NSEvent *)theEvent {
	NSLog(@"Show Menu");
	NSMenu *menu = [[NSApp delegate] menu];//[self menu];
	[menu setDelegate:self];
	[NSMenu popUpContextMenu:menu withEvent:theEvent forView:nil];
	
	if([[self superview] respondsToSelector:@selector(setMenuDown:)])
		[(ProgressIndicator*)[self superview] setMenuDown:YES];
}

@end
