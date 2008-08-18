//
//  TODLiteral.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TODTerminal.h"

@class TODToken;

@interface TODLiteral : TODTerminal {
	TODToken *literal;
}
+ (id)literal;
+ (id)literalWithString:(NSString *)s;
@end
