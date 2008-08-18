//
//  TODXmlName.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/16/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODXmlName.h"
#import "TODXmlToken.h"

@implementation TODXmlName

+ (id)name {
	return [[[[self class] alloc] initWithString:nil] autorelease];
}


- (BOOL)qualifies:(id)obj {
	TODXmlToken *tok = (TODXmlToken *)obj;
	return tok.isName;
}

@end
