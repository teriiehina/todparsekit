//
//  TODWord.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TODParseKit/TODWord.h>
#import <TODParseKit/TODToken.h>
#import <TODParseKit/TODAssembly.h>

@implementation TODWord

+ (id)word {
	return [[[[self class] alloc] initWithString:nil] autorelease];
}


+ (id)wordWithString:(NSString *)s {
	return [[[[self class] alloc] initWithString:s] autorelease];
}


- (BOOL)qualifies:(id)obj {
	TODToken *tok = (TODToken *)obj;
	return tok.isWord;
}

@end
