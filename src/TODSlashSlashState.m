//
//  TODSlashSlashState.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2006 Todd Ditchendorf. All rights reserved.
//

#import <TODParseKit/TODSlashSlashState.h>
#import <TODParseKit/TODReader.h>
#import <TODParseKit/TODTokenizer.h>

@implementation TODSlashSlashState

- (TODToken *)nextTokenFromReader:(TODReader *)r startingWith:(NSInteger)cin tokenizer:(TODTokenizer *)t {
	NSInteger c;
	do {
		c = [r read];
		
		// TODO should we be handling carriage returns??
	} while (c != '\n' && c != '\r' && c != -1);
	
	return [t nextToken];
}

@end
