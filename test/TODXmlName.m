//
//  TODXmlName.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/16/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODXmlName.h"
#import "TODToken.h"

@implementation TODXmlName

+ (id)name {
	return [[[[self class] alloc] initWithString:nil] autorelease];
}


- (BOOL)qualifies:(id)obj {
	TODToken *tok = (TODToken *)obj;
	if (!tok.isWord) {
		return NO;
	}
	
	//NSString *s = tok.stringValue;
	if (YES) {
		
	}
	
	return YES;
}

@end
