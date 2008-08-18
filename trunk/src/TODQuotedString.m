//
//  TODQuotedString.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TODParseKit/TODQuotedString.h>
#import <TODParseKit/TODToken.h>

@implementation TODQuotedString

+ (id)quotedString {
	return [[[[self class] alloc] initWithString:nil] autorelease];
}


+ (id)quotedStringWithString:(NSString *)s {
	return [[[[self class] alloc] initWithString:s] autorelease];
}


- (BOOL)qualifies:(id)obj {
	TODToken *tok = (TODToken *)obj;
	return tok.isQuotedString;
}

@end
