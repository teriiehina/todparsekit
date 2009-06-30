//
//  TDLetter.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <ParseKit/TDLetter.h>
#import <ParseKit/PKTypes.h>

@implementation TDLetter

+ (id)letter {
    return [[[self alloc] initWithString:nil] autorelease];
}


- (BOOL)qualifies:(id)obj {
    TDUniChar c = [obj intValue];
    return isalpha(c);
}

@end
