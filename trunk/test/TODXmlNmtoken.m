//
//  TODXmlNmtoken.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/16/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODXmlNmtoken.h"
#import "TODXmlToken.h"

@implementation TODXmlNmtoken

+ (id)nmtoken {
	return [[[[self class] alloc] initWithString:nil] autorelease];
}


//- (BOOL)qualifies:(id)obj {
//	TODXmlToken *tok = (TODXmlToken *)obj;
//	return tok.isNmtoken;
//}

@end
