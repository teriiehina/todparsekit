//
//  TODXmlComment.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TODXmlComment.h"
#import "TODXmlToken.h"

@implementation TODXmlComment

+ (id)comment {
	return [[[[self class] alloc] initWithString:nil] autorelease];
}


+ (id)commentWithString:(NSString *)s {
	return [[[[self class] alloc] initWithString:s] autorelease];
}


- (id)initWithString:(NSString *)s {
	self = [super init];
	if (self != nil) {
		self.tok = [TODXmlToken tokenWithTokenType:TODTT_XML_COMMENT stringValue:s];
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
		return other.isComment;
	}
}

@end
