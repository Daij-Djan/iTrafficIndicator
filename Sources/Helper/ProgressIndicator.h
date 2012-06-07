//
//  ProgressIndicator.h
//  iPhoneLikeIndicator
//
//  Created by Dominik Pich on 12.09.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface ProgressIndicator : NSView {
	NSProgressIndicator *indicatorView;
	NSStatusItem *statusItem;
	
	BOOL isAnimating;
	BOOL menuDown;
}

- (void)setStatusItem:(NSStatusItem*)item;
- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;

- (void)setMenuDown:(BOOL)flag;
- (BOOL)isMenuDown;
@end
