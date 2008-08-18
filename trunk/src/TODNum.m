//
//  TODNum.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TODParseKit/TODNum.h>
#import <TODParseKit/TODToken.h>

@implementation TODNum

+ (id)num {
	return [[[[self class] alloc] initWithString:nil] autorelease];
}


+ (id)numWithString:(NSString *)s {
	return [[[[self class] alloc] initWithString:s] autorelease];
}


- (BOOL)qualifies:(id)obj {
	TODToken *tok = (TODToken *)obj;
	return tok.isNumber;
}

@end