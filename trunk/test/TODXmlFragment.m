//
//  TODXmlFragment.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TODXmlFragment.h"
#import "TODXmlToken.h"

@implementation TODXmlFragment

+ (id)doctype {
	return [[[[self class] alloc] initWithString:nil] autorelease];
}


+ (id)doctypeWithString:(NSString *)s {
	return [[[[self class] alloc] initWithString:s] autorelease];
}


- (id)initWithString:(NSString *)s {
	self = [super init];
	if (self != nil) {
		self.tok = [TODXmlToken tokenWithTokenType:TODTT_XML_FRAGMENT stringValue:s];
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
		return other.isFragment;
	}
}

@end
