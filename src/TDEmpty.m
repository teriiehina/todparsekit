//
//  TDEmpty.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDEmpty.h>

@interface TDParser ()
+ (NSSet *)deepCopy:(NSSet *)inSet;
@end

@implementation TDEmpty

+ (id)empty {
	return [[[self alloc] init] autorelease];
}


- (NSSet *)allMatchesFor:(NSSet *)inAssemblies {
	return [[TDParser deepCopy:inAssemblies] autorelease];
}

@end
