//
//  TDSymbol.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDSymbol.h>
#import <TDParseKit/TDToken.h>

@interface TDSymbol ()
@property (nonatomic, retain) TDToken *symbolTok;
@end

@implementation TDSymbol

+ (id)symbol {
    return [[[self alloc] initWithString:nil] autorelease];
}


+ (id)symbolWithString:(NSString *)s {
    return [[[self alloc] initWithString:s] autorelease];
}


- (id)initWithString:(NSString *)s {
    self = [super initWithString:s];
    if (self != nil) {
        if (s.length) {
            self.symbolTok = [TDToken tokenWithTokenType:TDTokenTypeSymbol stringValue:s floatValue:0.0f];
        }
    }
    return self;
}


- (void)dealloc {
    self.symbolTok = nil;
    [super dealloc];
}


- (BOOL)qualifies:(id)obj {
    if (symbolTok) {
        return [symbolTok isEqual:obj];
    } else {
        TDToken *tok = (TDToken *)obj;
        return tok.isSymbol;
    }
}


- (NSString *)description {
    if (name.length) {
        return [NSString stringWithFormat:@"%@ (%@) %@", [[self className] substringFromIndex:2], name, symbolTok.stringValue];
    } else {
        return [NSString stringWithFormat:@"%@ %@", [[self className] substringFromIndex:2], symbolTok.stringValue];
    }
}

@synthesize symbolTok;
@end
