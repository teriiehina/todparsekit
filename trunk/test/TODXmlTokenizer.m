//
//  TODXmlTokenizer.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TODXmlTokenizer.h"
#import "XMLPullParser.h"
#import "TODXmlToken.h"

@interface TODXmlTokenizer ()
@property (nonatomic, retain) XMLPullParser *reader;
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
		self.reader = [[[XMLPullParser alloc] initWithContentsOfFile:path] autorelease];
	}
	return self;
}


- (void)dealloc {
	self.reader = nil;
	[super dealloc];
}


- (TODXmlToken *)nextToken {
	NSInteger ret = [reader read];
	
	TODXmlToken *tok = nil;
	
	if (-1 == ret) {
		tok = [TODXmlToken EOFToken];
	} else {
		tok = [TODXmlToken tokenWithTokenType:ret stringValue:reader.name floatValue:0.0f];
	}
	
	return tok;
}

@synthesize reader;
@end
