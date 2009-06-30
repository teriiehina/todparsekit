//
//  TDTokenizerState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <ParseKit/TDTokenizerState.h>
#import <ParseKit/TDTokenizer.h>
#import <ParseKit/PKReader.h>
#import <ParseKit/PKTypes.h>

@interface TDTokenizer ()
- (TDTokenizerState *)defaultTokenizerStateFor:(PKUniChar)c;
@end

@interface TDTokenizerState ()
- (void)resetWithReader:(PKReader *)r;
- (void)append:(PKUniChar)c;
- (void)appendString:(NSString *)s;
- (NSString *)bufferedString;
- (TDTokenizerState *)nextTokenizerStateFor:(PKUniChar)c tokenizer:(TDTokenizer *)t;

@property (nonatomic, retain) NSMutableString *stringbuf;
@property (nonatomic) NSUInteger offset;
@end

@implementation TDTokenizerState

- (void)dealloc {
    self.stringbuf = nil;
    self.fallbackState = nil;
    [super dealloc];
}


- (TDToken *)nextTokenFromReader:(PKReader *)r startingWith:(PKUniChar)cin tokenizer:(TDTokenizer *)t {
    NSAssert1(0, @"TDTokenizerState is an abstract classs. %s must be overriden", _cmd);
    return nil;
}


- (void)resetWithReader:(PKReader *)r {
    self.stringbuf = [NSMutableString string];
    self.offset = r.offset - 1;
}


- (void)append:(PKUniChar)c {
    NSParameterAssert(c > -1);
    [stringbuf appendFormat:@"%C", c];
}


- (void)appendString:(NSString *)s {
    NSParameterAssert(s);
    [stringbuf appendString:s];
}


- (NSString *)bufferedString {
    return [[stringbuf copy] autorelease];
}


- (TDTokenizerState *)nextTokenizerStateFor:(PKUniChar)c tokenizer:(TDTokenizer *)t {
    if (fallbackState) {
        return fallbackState;
    } else {
        return [t defaultTokenizerStateFor:c];
    }
}

@synthesize stringbuf;
@synthesize offset;
@synthesize fallbackState;
@end
