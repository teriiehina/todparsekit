//
//  TODNonReservedWord.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TODParseKit/TODNonReservedWord.h>
#import <TODParseKit/TODReservedWord.h>
#import <TODParseKit/TODToken.h>

@interface TODReservedWord ()
+ (NSArray *)reservedWords;
@end

@implementation TODNonReservedWord

- (BOOL)qualifies:(id)obj {
	TODToken *tok = (TODToken *)obj;
	if (!tok.isWord) {
		return NO;
	}
	
	NSString *s = tok.stringValue;
	return s.length && ![[TODReservedWord reservedWords] containsObject:s];
}

@end
