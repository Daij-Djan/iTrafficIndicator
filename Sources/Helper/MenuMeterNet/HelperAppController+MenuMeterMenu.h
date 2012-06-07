//
//  AppController+MenuMeterMenu.h
//  iPhoneLikeIndicator
//
//  Created by Dominik Pich on 4/9/11.
//  Copyright 2011 FHK Gummersbach. All rights reserved.
//

#import "HelperAppController.h"


@interface HelperAppController (MenuMeterMenu)
- (void)prepareLocalizedData;

- (NSMenu *)menu;
- (void)updateMenuWhileDown;
@end
