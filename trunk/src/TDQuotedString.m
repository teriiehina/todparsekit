//
//  TDQuotedString.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <ParseKit/TDQuotedString.h>
#import <ParseKit/PKToken.h>

@implementation TDQuotedString

+ (id)quotedString {
    return [[[self alloc] initWithString:nil] autorelease];
}


- (BOOL)qualifies:(id)obj {
    PKToken *tok = (PKToken *)obj;
    return tok.isQuotedString;
}

@end
