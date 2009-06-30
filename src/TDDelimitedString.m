//
//  TDDelimitedString.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 5/21/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <ParseKit/TDDelimitedString.h>
#import <ParseKit/TDToken.h>

@interface TDDelimitedString ()
@property (nonatomic, retain) NSString *startMarker;
@property (nonatomic, retain) NSString *endMarker;
@end

@implementation TDDelimitedString

+ (id)delimitedString {
    return [self delimitedStringWithStartMarker:nil];
}


+ (id)delimitedStringWithStartMarker:(NSString *)start {
    return [self delimitedStringWithStartMarker:start endMarker:nil];
}


+ (id)delimitedStringWithStartMarker:(NSString *)start endMarker:(NSString *)end {
    TDDelimitedString *ds = [[[self alloc] initWithString:nil] autorelease];
    ds.startMarker = start;
    ds.endMarker = end;
    return ds;
}


- (void)dealloc {
    self.startMarker = nil;
    self.endMarker = nil;
    [super dealloc];
}


- (BOOL)qualifies:(id)obj {
    TDToken *tok = (TDToken *)obj;
    BOOL result = tok.isDelimitedString;
    if (result && startMarker.length) {
        result = [tok.stringValue hasPrefix:startMarker];
        if (result && endMarker.length) {
            result = [tok.stringValue hasSuffix:endMarker];
        }
    }
    return result;
}

@synthesize startMarker;
@synthesize endMarker;
@end