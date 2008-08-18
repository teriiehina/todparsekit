//
//  TODCollectionParser.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODCollectionParser.h"

@interface TODCollectionParser ()
@property (nonatomic, readwrite, retain) NSMutableArray *subparsers;
@end

@implementation TODCollectionParser

- (id)init {
	self = [super init];
	if (self != nil) {
		self.subparsers = [NSMutableArray array];
	}
	return self;
}


- (void)dealloc {
	self.subparsers = nil;
	[super dealloc];
}


- (void)add:(TODParser *)p {
	[subparsers addObject:p];
}

@synthesize subparsers;
@end
