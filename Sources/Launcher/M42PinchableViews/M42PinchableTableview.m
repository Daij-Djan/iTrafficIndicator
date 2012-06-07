//
//  ZoomableTableview.m
//  Medikamente
//
//  Created by Dominik Pich on 1/28/11.
//  Copyright 2011 FHK Gummersbach. All rights reserved.
//

#import "M42PinchableTableview.h"

@implementation M42PinchableTableview

- (CGFloat)textSizeMultiplier {
	return textSizeMultiplier;
}

- (void)setTextSizeMultiplier:(CGFloat)newTextSizeMultiplier {
	textSizeMultiplier = newTextSizeMultiplier;
	
    NSArray *tableColumns;
    unsigned int columnIndex;
    
    tableColumns = [self tableColumns];
    columnIndex = [tableColumns count];
    while (columnIndex--) {
        NSFont *font = [[(NSTableColumn *)[tableColumns objectAtIndex:columnIndex] dataCell] font];	
		font = [[NSFontManager sharedFontManager] convertFont:font toSize:[NSFont systemFontSize]*textSizeMultiplier];
        [[(NSTableColumn *)[tableColumns objectAtIndex:columnIndex] dataCell] setFont:font];	
	}
	
	[self reloadData];
}

- (void)magnifyWithEvent:(NSEvent *)event {
	CGFloat old = [self textSizeMultiplier];
	[self setTextSizeMultiplier:old+[event magnification]*0.8];
}

-(IBAction)zoomIn:(id)sender {
	CGFloat old = [self textSizeMultiplier];
	[self setTextSizeMultiplier:old+0.4];
}

-(IBAction)zoomOut:(id)sender {
	CGFloat old = [self textSizeMultiplier];
	[self setTextSizeMultiplier:old-0.4];
}

@end
