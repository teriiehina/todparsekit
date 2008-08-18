//
//  TODEmpty.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODEmpty.h"

@interface TODParser ()
+ (NSSet *)deepCopy:(NSSet *)inSet;
@end

@implementation TODEmpty

+ (id)empty {
	return [[[[self class] alloc] init] autorelease];
}


- (NSSet *)allMatchesFor:(NSSet *)inAssemblies {
	return [[TODParser deepCopy:inAssemblies] autorelease];
}

@end
