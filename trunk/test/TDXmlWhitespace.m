//
//  TDXmlWhitespace.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/20/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDXmlWhitespace.h"
#import "TDXmlToken.h"

@implementation TDXmlWhitespace

+ (id)whitespace {
	return [[[self alloc] initWithString:nil] autorelease];
}


+ (id)whitespaceWithString:(NSString *)s {
	return [[[self alloc] initWithString:s] autorelease];
}


- (id)initWithString:(NSString *)s {
	self = [super initWithString:s];
	if (self != nil) {
		self.tok = [TDXmlToken tokenWithTokenType:TDTT_XML_WHITESPACE stringValue:s];
	}
	return self;
}


- (void)dealloc {
	[super dealloc];
}


- (BOOL)qualifies:(id)obj {
	TDXmlToken *other = (TDXmlToken *)obj;
	
	if (string.length) {
		return [tok isEqual:other];
	} else {
		return other.isWhitespace;
	}
}

@end
