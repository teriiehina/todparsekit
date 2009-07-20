//
//  PKParseTree.h
//  ParseKit
//
//  Created by Todd Ditchendorf on 7/11/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PKRuleNode;
@class PKTokenNode;
@class PKToken;

@interface PKParseTree : NSObject {
    NSMutableArray *children;
}

- (PKRuleNode *)addChildRule:(NSString *)name;
- (PKTokenNode *)addChildToken:(PKToken *)tok;
- (void)addChild:(PKParseTree *)tr;

@property (nonatomic, retain, readonly) NSMutableArray *children;
@end
