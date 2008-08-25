//
//  TDNum.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDNum.h>
#import <TDParseKit/TDToken.h>

@implementation TDNum

+ (id)num {
	return [[[[self class] alloc] initWithString:nil] autorelease];
}


- (BOOL)qualifies:(id)obj {
	TDToken *tok = (TDToken *)obj;
	return tok.isNumber;
}

@end