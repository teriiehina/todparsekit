//
//  PKUppercaseWord.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 8/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <ParseKit/TDUppercaseWord.h>
#import <ParseKit/PKToken.h>

@implementation TDUppercaseWord

- (BOOL)qualifies:(id)obj {
    PKToken *tok = (PKToken *)obj;
    if (!tok.isWord) {
        return NO;
    }
    
    NSString *s = tok.stringValue;
    return s.length && isupper([s characterAtIndex:0]);
}

@end
