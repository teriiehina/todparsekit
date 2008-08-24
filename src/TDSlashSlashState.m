//
//  TDSlashSlashState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDSlashSlashState.h>
#import <TDParseKit/TDReader.h>
#import <TDParseKit/TDTokenizer.h>

@implementation TDSlashSlashState

- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(NSInteger)cin tokenizer:(TDTokenizer *)t {
	NSInteger c;
	do {
		c = [r read];
		
		// TDO should we be handling carriage returns??
	} while (c != '\n' && c != '\r' && c != -1);
	
	return [t nextToken];
}

@end
