//
//  TODRepetition.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TODParser.h"

@interface TODRepetition : TODParser {
	TODParser *subparser;
	id preAssembler;
	SEL preAssemblerSelector;
}
+ (id)repetition;
+ (id)repetitionWithSubparser:(TODParser *)p;

// designated initializer
- (id)initWithSubparser:(TODParser *)p;

@end
