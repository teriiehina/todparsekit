//
//  TDWhitespace.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 6/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDWhitespace.h"
#import <ParseKit/TDToken.h>

@implementation TDWhitespace

+ (id)whitespace {
    return [[[self alloc] initWithString:nil] autorelease];
}


- (BOOL)qualifies:(id)obj {
    TDToken *tok = (TDToken *)obj;
    return tok.isWhitespace;
}

@end