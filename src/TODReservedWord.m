//
//  TODReservedWord.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODReservedWord.h"
#import "TODToken.h"

static NSArray *sTODReservedWords = nil;

@interface TODReservedWord ()
+ (NSArray *)reservedWords;
@end

@implementation TODReservedWord

+ (NSArray *)reservedWords {
	return [[sTODReservedWords copy] autorelease];
}


+ (void)setReservedWords:(NSArray *)inWords {
	if (inWords != sTODReservedWords) {
		[sTODReservedWords autorelease];
		sTODReservedWords = [inWords copy];
	}
}


- (BOOL)qualifies:(id)obj {
	TODToken *tok = (TODToken *)obj;
	if (!tok.isWord) {
		return NO;
	}
	
	NSString *s = tok.stringValue;
	return s.length && [[TODReservedWord reservedWords] containsObject:s];
}

@end
