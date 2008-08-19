//
//  TODCharbufState.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 7/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TODParseKit/TODTokenizerState.h>

// NOTE: this class is not currently in use or included in the build Framework. Using TODMutableStringState instead

// Abstract Class
@interface TODCharbufState : TODTokenizerState {
	char *__strong charbuf;
	NSInteger len;
}
- (void)reset;
- (void)checkBufLength:(NSInteger)i;
- (char *)mallocCharbuf:(NSInteger)size;
@end
