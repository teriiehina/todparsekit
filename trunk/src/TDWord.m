//
//  TDWord.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDWord.h>
#import <TDParseKit/TDToken.h>

@interface TDTerminal ()
- (BOOL)except:(id)obj;
@end

@implementation TDWord

+ (id)word {
    return [[[self alloc] initWithString:nil] autorelease];
}


- (BOOL)qualifies:(id)obj {
    TDToken *tok = (TDToken *)obj;
    return tok.isWord && ![self except:tok.value];
}

@end
