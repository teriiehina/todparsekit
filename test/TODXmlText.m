//
//  TODXmlText.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TODXmlText.h"
#import "TODXmlToken.h"

@implementation TODXmlText

+ (id)text {
	return [[[[self class] alloc] initWithString:nil] autorelease];
}


+ (id)textWithString:(NSString *)s {
	return [[[[self class] alloc] initWithString:s] autorelease];
}


- (id)initWithString:(NSString *)s {
	NSLog(@"%s", _cmd);
	self = [super initWithString:s];
	if (self != nil) {
		self.tok = [TODXmlToken tokenWithTokenType:TODTT_XML_TEXT stringValue:s];
		NSLog(@"tok : %@", tok);
	}
	return self;
}


- (void)dealloc {
	[super dealloc];
}


- (BOOL)qualifies:(id)obj {
	TODXmlToken *other = (TODXmlToken *)obj;
	NSLog(@"%s obj: %@ isText: %d", _cmd, obj, other.isText);
	
	if (string.length) {
		return [tok isEqual:other];
	} else {
		return other.isText;
	}
}

@end
