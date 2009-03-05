//
//  TDParseKitState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDTokenizerState.h>

@interface TDTokenizerState ()
- (void)reset;
- (void)append:(NSInteger)c;
- (void)appendString:(NSString *)s;
- (NSString *)bufferedString;

@property (nonatomic, retain) NSMutableString *stringbuf;
@end

@implementation TDTokenizerState

- (void)dealloc {
    self.stringbuf = nil;
    [super dealloc];
}


- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(NSInteger)cin tokenizer:(TDTokenizer *)t {
    NSAssert(0, @"TDTokenizerState is an Abstract Classs. nextTokenFromStream:at:tokenizer: must be overriden");
    return nil;
}


- (void)reset {
    self.stringbuf = [NSMutableString string];
}


- (void)append:(NSInteger)c {
    [stringbuf appendFormat:@"%C", c];
}


- (void)appendString:(NSString *)s {
    [stringbuf appendString:s];
}


- (NSString *)bufferedString {
    return [[stringbuf copy] autorelease];
}

@synthesize stringbuf;
@end
