//
//  TDDelimitedString.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 5/21/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDDelimitedString.h>
#import <TDParseKit/TDToken.h>

@interface TDTerminal ()
- (BOOL)except:(id)obj;
@end

@implementation TDDelimitedString

+ (id)delimitedString {
    return [[[self alloc] initWithString:nil] autorelease];
}


- (BOOL)qualifies:(id)obj {
    TDToken *tok = (TDToken *)obj;
    return tok.isDelimitedString && ![self except:tok.value];
}

@end