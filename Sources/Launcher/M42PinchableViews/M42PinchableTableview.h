//
//  ZoomableTableview.h
//  Medikamente
//
//  Created by Dominik Pich on 1/28/11.
//  Copyright 2011 FHK Gummersbach. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface M42PinchableTableview : NSTableView {
	CGFloat textSizeMultiplier;
}
- (CGFloat)textSizeMultiplier;
- (void)setTextSizeMultiplier:(CGFloat)newTextSizeMultiplier;
	
-(IBAction)zoomIn:(id)sender;
-(IBAction)zoomOut:(id)sender;

@end
