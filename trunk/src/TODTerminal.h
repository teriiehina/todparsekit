//
//  TODTerminal.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TODParser.h"

@class TODToken;

// Abstract class
@interface TODTerminal : TODParser {
	NSString *string;
	BOOL discard;
}
+ (id)terminal;
+ (id)terminalWithString:(NSString *)s;
- (id)initWithString:(NSString *)s;

- (TODTerminal *)discard;

@property (nonatomic, readonly, copy) NSString *string;
@end
