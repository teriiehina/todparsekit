//
//  TDComment.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/31/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <ParseKit/TDComment.h>
#import <ParseKit/PKToken.h>

@implementation TDComment

+ (id)comment {
    return [[[self alloc] initWithString:nil] autorelease];
}


- (BOOL)qualifies:(id)obj {
    PKToken *tok = (PKToken *)obj;
    return tok.isComment;
}

@end