//
//  TODXmlToken.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/16/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODXmlToken.h"

const NSInteger TODTT_NAME = 6;
const NSInteger TODTT_NMTOKEN = 7;

@interface TODXmlToken ()
@property (readwrite, getter=isName) BOOL name;
@property (readwrite, getter=isNmtoken) BOOL nmtoken;
@end

@implementation TODXmlToken

- (id)initWithTokenType:(TODTokenType)t stringValue:(NSString *)s floatValue:(CGFloat)n {
	self = [super initWithTokenType:t stringValue:s floatValue:n];
	if (self != nil) {
		self.name = (t == TODTT_NAME);
		self.nmtoken = (t == TODTT_NMTOKEN);
	}
	return self;
}

@synthesize name;
@synthesize nmtoken;
@end
