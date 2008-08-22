//
//  TODXmlNotation.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TODXmlNotation.h"
#import "TODXmlToken.h"

@implementation TODXmlNotation

+ (id)notation {
	return [[[[self class] alloc] initWithString:nil] autorelease];
}


+ (id)notationWithString:(NSString *)s {
	return [[[[self class] alloc] initWithString:s] autorelease];
}


- (id)initWithString:(NSString *)s {
	self = [super initWithString:s];
	if (self != nil) {
		self.tok = [TODXmlToken tokenWithTokenType:TODTT_XML_NOTATION stringValue:s];
	}
	return self;
}


- (void)dealloc {
	[super dealloc];
}


- (BOOL)qualifies:(id)obj {
	TODXmlToken *other = (TODXmlToken *)obj;
	
	if (string.length) {
		return [tok isEqual:other];
	} else {
		return other.isNotation;
	}
}

@end
