//
//  TODCaseInsensitiveLiteral.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODCaseInsensitiveLiteral.h"
#import "TODToken.h"

@implementation TODCaseInsensitiveLiteral

- (BOOL)matches:(id)obj {
	TODToken *tok = (TODToken *)obj;
	return (NSOrderedSame == [tok.stringValue caseInsensitiveCompare:string]);
}


- (BOOL)qualifies:(id)obj {
	return [literal isEqualIgnoringCase:obj];
}

@end
