//
//  PKParseTreeAssembler.h
//  ParseKit
//
//  Created by Todd Ditchendorf on 7/11/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PKParseTree;
@class PKAssembly;

@interface PKParseTreeAssembler : NSObject {
    NSMutableDictionary *ruleNames;
    NSString *assemblerPrefix;
    NSString *preassemblerPrefix;
    NSString *suffix;
}

@end
