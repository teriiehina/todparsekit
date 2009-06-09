//
//  TDAny.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDAny.h>
#import <TDParseKit/TDToken.h>

@implementation TDAny

+ (id)any {
    return [[[self alloc] init] autorelease];
}


- (BOOL)qualifies:(id)obj {
    return [obj isKindOfClass:[TDToken class]];
}

@end
