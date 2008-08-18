//
//  TODCharbufState.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 7/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TODTokenizerState.h"

// Abstract Class
@interface TODCharbufState : TODTokenizerState {
	char *charbuf;
	NSInteger len;
}
- (void)reset;
- (void)checkBufLength:(NSInteger)i;
- (char *)mallocCharbuf:(NSInteger)size;
@end
