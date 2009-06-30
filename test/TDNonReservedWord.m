//
//  TDNonReservedWord.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <ParseKit/TDNonReservedWord.h>
#import <ParseKit/TDReservedWord.h>
#import <ParseKit/TDToken.h>

@interface TDReservedWord ()
+ (NSArray *)reservedWords;
@end

@implementation TDNonReservedWord

- (BOOL)qualifies:(id)obj {
    TDToken *tok = (TDToken *)obj;
    if (!tok.isWord) {
        return NO;
    }
    
    NSString *s = tok.stringValue;
    return s.length && ![[TDReservedWord reservedWords] containsObject:s];
}

@end
