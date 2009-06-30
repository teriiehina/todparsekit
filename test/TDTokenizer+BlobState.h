//
//  PKTokenizer+BlobState.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 6/7/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <ParseKit/PKTokenizer.h>

@class TDBlobState;

@interface PKTokenizer (BlobState)
- (TDBlobState *)blobState;
@end
