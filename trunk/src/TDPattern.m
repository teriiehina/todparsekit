//
//  TDPattern.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 5/31/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDPattern.h>
#import <TDParseKit/TDToken.h>
#import "RegexKitLite.h"

@implementation TDPattern

+ (id)patternWithString:(NSString *)s {
    return [[[self alloc] initWithString:s] autorelease];
}


- (BOOL)qualifies:(id)obj {
    TDToken *tok = (TDToken *)obj;
    return [tok.stringValue isMatchedByRegex:self.string];
}

@end
