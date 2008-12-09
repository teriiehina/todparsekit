//
//  TDCaseInsensitiveLiteral.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDCaseInsensitiveLiteral.h>
#import <TDParseKit/TDToken.h>

@implementation TDCaseInsensitiveLiteral

- (BOOL)qualifies:(id)obj {
    return [literal isEqualIgnoringCase:obj];
}

@end