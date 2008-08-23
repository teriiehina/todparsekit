//
//  TODXmlTokenizer.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TODXmlTokenizer.h"
#import "XMLReader.h"
#import "TODXmlToken.h"

@interface TODXmlTokenizer ()
@property (nonatomic, retain) XMLReader *reader;
@end

@implementation TODXmlTokenizer

+ (id)tokenizerWithContentsOfFile:(NSString *)path {
	return [[[[self class] alloc] initWithContentsOfFile:path] autorelease];
}


- (id)init {
	return nil;
}


- (id)initWithContentsOfFile:(NSString *)path {
	self = [super init];
	if (self != nil) {
		self.reader = [[[XMLReader alloc] initWithContentsOfFile:path] autorelease];
	}
	return self;
}


- (void)dealloc {
	self.reader = nil;
	[super dealloc];
}


- (TODXmlToken *)nextToken {
	TODXmlToken *tok = nil;
	NSInteger ret = -1;
	NSInteger nodeType = -1;
	
	do {
		ret = [reader read];		
		nodeType = reader.nodeType;
	} while (nodeType == TODTT_XML_SIGNIFICANT_WHITESPACE || nodeType == TODTT_XML_WHITESPACE);

	if (ret <= 0) {
		tok = [TODXmlToken EOFToken];
	} else {
		tok = [TODXmlToken tokenWithTokenType:reader.nodeType stringValue:reader.name];
	}
	
	return tok;
}

@synthesize reader;
@end
