//
//  TDParseKitState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDTokenizerState.h>
#import <TDParseKit/TDTypes.h>

@interface TDTokenizerState ()
- (void)reset;
- (void)append:(TDUniChar)c;
- (void)appendString:(NSString *)s;
- (NSString *)bufferedString;

@property (nonatomic, retain) NSMutableString *stringbuf;
@end

@implementation TDTokenizerState

- (void)dealloc {
    self.stringbuf = nil;
    [super dealloc];
}


- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(TDUniChar)cin tokenizer:(TDTokenizer *)t {
    NSAssert(0, @"TDTokenizerState is an Abstract Classs. nextTokenFromStream:at:tokenizer: must be overriden");
    return nil;
}


- (void)reset {
    self.stringbuf = [NSMutableString string];
}


- (void)append:(TDUniChar)c {
    NSParameterAssert(c > 0);
    CFStringAppendCharacters((CFMutableStringRef)stringbuf, (const UniChar *)&c, 1);
}


- (void)appendString:(NSString *)s {
    [stringbuf appendString:s];
}


- (NSString *)bufferedString {
    return [[stringbuf copy] autorelease];
}

@synthesize stringbuf;
@end
