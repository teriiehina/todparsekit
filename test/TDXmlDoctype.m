//
//  TDXmlDoctype.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TDXmlDoctype.h"
#import "TDXmlToken.h"

@implementation TDXmlDoctype

+ (id)doctype {
	return [[[[self class] alloc] initWithString:nil] autorelease];
}


+ (id)doctypeWithString:(NSString *)s {
	return [[[[self class] alloc] initWithString:s] autorelease];
}


- (id)initWithString:(NSString *)s {
	self = [super initWithString:s];
	if (self != nil) {
		self.tok = [TDXmlToken tokenWithTokenType:TDTT_XML_DOCTYPE stringValue:s];
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
		return other.isDoctype;
	}
}

@end
