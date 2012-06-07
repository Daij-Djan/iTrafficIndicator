//
//  NSUserDefaults+deviceBasedDefaults.h
//  Project
//
//  Created by Dominik Pich on 06.11.09.
//  Copyright 2009 Medicus 42 GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@class M42Defaults;

@interface NSUserDefaults (AR)
+ (M42Defaults*)arUserDefaults;
@end
