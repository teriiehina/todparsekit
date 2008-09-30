//
//  TDXmlProcessingInstruction.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/20/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDXmlProcessingInstruction.h"
#import "TDXmlToken.h"

@implementation TDXmlProcessingInstruction

+ (id)processingInstruction {
	return [[[[self class] alloc] initWithString:nil] autorelease];
}


+ (id)processingInstructionWithString:(NSString *)s {
	return [[[[self class] alloc] initWithString:s] autorelease];
}


- (id)initWithString:(NSString *)s {
	self = [super initWithString:s];
	if (self != nil) {
		self.tok = [TDXmlToken tokenWithTokenType:TDTT_XML_PROCESSING_INSTRUCTION stringValue:s];
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
		return other.isProcessingInstruction;
	}
}

@end
