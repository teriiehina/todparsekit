//
//  TODNCName.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/16/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODNCName.h"

const NSInteger TODTT_NCNAME = 6;

@implementation TODToken (NCNameAdditions)

- (BOOL)isNCName {
	return self.tokenType == TODTT_NCNAME;
}

@end

@implementation TODNCName

+ (id)NCName {
	return [[[[self class] alloc] initWithString:nil] autorelease];
}


- (BOOL)qualifies:(id)obj {
	TODToken *tok = (TODToken *)obj;
	return tok.isNCName;
}

@end
