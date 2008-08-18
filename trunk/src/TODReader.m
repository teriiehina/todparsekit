//
//  TODPushbackInputStream.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 1/21/06.
//  Copyright 2006 Todd Ditchendorf. All rights reserved.
//

#import <TODParseKit/TODReader.h>

@implementation TODReader

- (id)init {
	return [self initWithString:nil];
}


- (id)initWithString:(NSString *)s {
	self = [super init];
	if (self != nil) {
		self.string = s;
	}
	return self;
}


- (void)dealloc {
	self.string = nil;
	[super dealloc];
}


- (NSString *)string {
	return [[string copy] autorelease];
}


- (void)setString:(NSString *)s {
	if (string != s) {
		[string autorelease];
		string = [s copy];
	}
	// reset cursor
	cursor = 0;
}


- (NSInteger)read {
	if (cursor > ((NSInteger)string.length) - 1) {
		return -1;
	}
	return [string characterAtIndex:cursor++];
}


- (void)unread {
	cursor = (--cursor < 0) ? 0 : cursor;
}

@end
