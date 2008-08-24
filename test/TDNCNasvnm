//
//  TDNCName.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/16/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDNCName.h"

const NSInteger TDTT_NCNAME = 6;

@implementation TDToken (NCNameAdditions)

- (BOOL)isNCName {
	return self.tokenType == TDTT_NCNAME;
}

@end

@implementation TDNCName

+ (id)NCName {
	return [[[[self class] alloc] initWithString:nil] autorelease];
}


- (BOOL)qualifies:(id)obj {
	TDToken *tok = (TDToken *)obj;
	return tok.isNCName;
}

@end
