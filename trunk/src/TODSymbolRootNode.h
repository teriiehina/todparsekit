//
//  TODSymbolRootNode.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2006 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TODSymbolNode.h"

@class TODReader;

@interface TODSymbolRootNode : TODSymbolNode {
}
- (void)add:(NSString *)s;
- (NSString *)nextSymbol:(TODReader *)r startingWith:(NSInteger)cin;
@end
