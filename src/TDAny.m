//
//  TDAny.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDAny.h>
#import <TDParseKit/TDToken.h>

@interface TDTerminal ()
- (BOOL)except:(id)obj;
@end

@implementation TDAny

+ (id)any {
    return [[[self alloc] initWithString:nil] autorelease];
}


- (BOOL)qualifies:(id)obj {
    if ([obj isKindOfClass:[TDToken class]]) {
        TDToken *tok = (TDToken *)obj;
        return ![self except:tok.value];
    } else {
        return NO;
    }
}

@end
