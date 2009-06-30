//
//  PKNCName.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 8/16/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDNCName.h"

const NSInteger TDTokenTypeNCName = 300;

@implementation PKToken (NCNameAdditions)

- (BOOL)isNCName {
    return self.tokenType == TDTokenTypeNCName;
}

@end

@implementation TDNCName

+ (id)NCName {
    return [[[self alloc] initWithString:nil] autorelease];
}


- (BOOL)qualifies:(id)obj {
    PKToken *tok = (PKToken *)obj;
    return tok.isNCName;
}

@end
