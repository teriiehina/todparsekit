//
//  TODParseKitState.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2006 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TODToken;
@class TODTokenizer;
@class TODReader;


@interface TODTokenizerState : NSObject {

}
- (TODToken *)nextTokenFromReader:(TODReader *)r startingWith:(NSInteger)cin tokenizer:(TODTokenizer *)t;
@end
