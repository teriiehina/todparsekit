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

- (BOOL)matches:(id)obj {
	TDToken *tok = (TDToken *)obj;
	return (NSOrderedSame == [tok.stringValue caseInsensitiveCompare:string]);
}


- (BOOL)qualifies:(id)obj {
	return [literal isEqualIgnoringCase:obj];
}

@end
