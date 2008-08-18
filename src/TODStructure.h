//
//  TODStructure.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/15/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TODTerm.h"

@interface TODStructure : NSObject <TODTerm> {
	id functor;
	NSArray *terms;
}
+ (id)structureWithFunctor:(id)f terms:(NSArray *)t;

- (id)initWithFunctor:(id)f terms:(NSArray *)t;
- (void)unify:(TODStructure *)s;

@property (nonatomic, copy) id functor;
@property (nonatomic, retain) NSArray *terms;
@end
