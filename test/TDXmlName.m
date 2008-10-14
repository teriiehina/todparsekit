//
//  TDXmlName.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/16/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDXmlName.h"
#import "TDToken.h"

@implementation TDXmlName

+ (id)name {
	return [[[self alloc] initWithString:nil] autorelease];
}


- (BOOL)qualifies:(id)obj {
	TDToken *tok = (TDToken *)obj;
	if (!tok.isWord) {
		return NO;
	}
	
	//NSString *s = tok.stringValue;
	if (YES) {
		
	}
	
	return YES;
}

@end
