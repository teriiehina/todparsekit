//
//  TDWord.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDWord.h>
#import <TDParseKit/TDToken.h>
#import <TDParseKit/TDAssembly.h>

@implementation TDWord

+ (id)word {
	return [[[[self class] alloc] initWithString:nil] autorelease];
}


+ (id)wordWithString:(NSString *)s {
	return [[[[self class] alloc] initWithString:s] autorelease];
}


- (BOOL)qualifies:(id)obj {
	TDToken *tok = (TDToken *)obj;
	return tok.isWord;
}

@end
