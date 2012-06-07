//
//  RLDefaults.m
//  Project
//
//  Created by Dominik Pich on 06.11.09.
//  Copyright 2009 Medicus 42 GmbH. All rights reserved.
//

#import "M42Defaults.h"


@implementation M42Defaults

- (id)initWithPath:(NSString*)aPath {
	self = [super init];
	
	path = [aPath copy];
	NSLog(@"init defaults with %@", path);
	if([[NSFileManager defaultManager] fileExistsAtPath:path])
		dict = [[NSDictionary alloc] initWithContentsOfFile:path];
	else
		dict = [[NSDictionary alloc] init];
	
	return self;
}

- (id)objectForKey:(NSString *)defaultName {
	return [dict objectForKey:defaultName];
}

- (void)setObject:(id)value forKey:(NSString *)defaultName {
	NSMutableDictionary *mDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
	[mDict setObject:value forKey:defaultName];

	if(![[NSFileManager defaultManager] fileExistsAtPath:path]) {
		NSString *dir = [path stringByDeletingLastPathComponent];
		[[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:0 error:nil];
	}
	
	[mDict writeToFile:path atomically:NO];
	[mDict release];
	
	[dict release];
	dict = [[NSDictionary alloc] initWithContentsOfFile:path];
}

- (void)removeObjectForKey:(NSString *)defaultName {
	NSMutableDictionary *mDict = [dict mutableCopy];
	[mDict removeObjectForKey:defaultName];

	if(![[NSFileManager defaultManager] fileExistsAtPath:path]) {
		NSString *dir = [path stringByDeletingLastPathComponent];
		[[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:0 error:nil];
	}

	[mDict writeToFile:path atomically:NO];
	[mDict release];
	
	[dict release];
	dict = [[NSDictionary alloc] initWithContentsOfFile:path];
}

#pragma mark -

- (NSString *)stringForKey:(NSString *)defaultName {
	return [self objectForKey:defaultName];
}

- (NSArray *)arrayForKey:(NSString *)defaultName {
	return [self objectForKey:defaultName];
}

- (NSDictionary *)dictionaryForKey:(NSString *)defaultName {
	return [self objectForKey:defaultName];
}

- (NSData *)dataForKey:(NSString *)defaultName {
	return [self objectForKey:defaultName];
}

- (NSArray *)stringArrayForKey:(NSString *)defaultName {
	return [self objectForKey:defaultName];
}

- (NSInteger)integerForKey:(NSString *)defaultName {
	id number = [self objectForKey:defaultName];
	return [number integerValue];
}

- (float)floatForKey:(NSString *)defaultName {
	id number = [self objectForKey:defaultName];
	return [number floatValue];
}

- (double)doubleForKey:(NSString *)defaultName {
	id number = [self objectForKey:defaultName];
	return [number doubleValue];
}

- (BOOL)boolForKey:(NSString *)defaultName {
	id number = [self objectForKey:defaultName];
	return [number boolValue];
}

#pragma mark -

- (void)setInteger:(NSInteger)value forKey:(NSString *)defaultName {
	[self setObject:[NSNumber numberWithInteger:value] forKey:defaultName];
}

- (void)setFloat:(float)value forKey:(NSString *)defaultName {
	[self setObject:[NSNumber numberWithFloat:value] forKey:defaultName];
}

- (void)setDouble:(double)value forKey:(NSString *)defaultName {
	[self setObject:[NSNumber numberWithDouble:value] forKey:defaultName];
}

- (void)setBool:(BOOL)value forKey:(NSString *)defaultName {
	[self setObject:[NSNumber numberWithBool:value] forKey:defaultName];
}

@end
