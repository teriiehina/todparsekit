//
//  TODChar.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TODParseKit/TODChar.h>

@implementation TODChar

+ (id)char {
	return [[[[self class] alloc] initWithString:nil] autorelease];
}


- (BOOL)qualifies:(id)obj {
	return YES;
}

@end
