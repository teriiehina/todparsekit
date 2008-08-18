//
//  TODSymbolState.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2006 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TODTokenizerState.h"

@class TODSymbolRootNode;

@interface TODSymbolState : TODTokenizerState {
	TODSymbolRootNode *rootNode;
}
- (void)add:(NSString *)s;
@end
