//
//  TDSpecificChar.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <ParseKit/TDSpecificChar.h>
#import <ParseKit/PKTypes.h>

@implementation TDSpecificChar

+ (id)specificCharWithChar:(TDUniChar)c {
    return [[[self alloc] initWithSpecificChar:c] autorelease];
}


- (id)initWithSpecificChar:(TDUniChar)c {
    self = [super initWithString:[NSString stringWithFormat:@"%C", c]];
    if (self) {
    }
    return self;
}


- (BOOL)qualifies:(id)obj {
    TDUniChar c = [obj intValue];
    return c == [string characterAtIndex:0];
}

@end
