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
    PKParseTree *rootNode;
//    PKParseTree *currentNode;

    NSMutableDictionary *ruleNames;
    NSString *prefix;
    NSString *suffix;
    
//    NSMutableArray *currentNodes;
}

//- (void)workOnRule:(PKAssembly *)a;
//- (void)workOnToken:(PKAssembly *)a;

@property (nonatomic, retain, readonly) PKParseTree *rootNode;
//@property (nonatomic, assign, readonly) PKParseTree *currentNode; //weak ref
@end
