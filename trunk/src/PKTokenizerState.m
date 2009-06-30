//
//  PKTokenizerState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <ParseKit/PKTokenizerState.h>
#import <ParseKit/PKTokenizer.h>
#import <ParseKit/PKReader.h>
#import <ParseKit/PKTypes.h>

@interface PKTokenizer ()
- (PKTokenizerState *)defaultTokenizerStateFor:(PKUniChar)c;
@end

@interface PKTokenizerState ()
- (void)resetWithReader:(PKReader *)r;
- (void)append:(PKUniChar)c;
- (void)appendString:(NSString *)s;
- (NSString *)bufferedString;
- (PKTokenizerState *)nextTokenizerStateFor:(PKUniChar)c tokenizer:(PKTokenizer *)t;

@property (nonatomic, retain) NSMutableString *stringbuf;
@property (nonatomic) NSUInteger offset;
@end

@implementation PKTokenizerState

- (void)dealloc {
    self.stringbuf = nil;
    self.fallbackState = nil;
    [super dealloc];
}


- (PKToken *)nextTokenFromReader:(PKReader *)r startingWith:(PKUniChar)cin tokenizer:(PKTokenizer *)t {
    NSAssert1(0, @"PKTokenizerState is an abstract classs. %s must be overriden", _cmd);
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


- (PKTokenizerState *)nextTokenizerStateFor:(PKUniChar)c tokenizer:(PKTokenizer *)t {
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
