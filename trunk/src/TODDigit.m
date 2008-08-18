//
//  TODDigit.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODDigit.h"

@implementation TODDigit

+ (id)digit {
	return [[[[self class] alloc] initWithString:nil] autorelease];
}


- (BOOL)qualifies:(id)obj {
	NSInteger c = [obj integerValue];
	return ('0' <= c && c <= '9');
}

@end
