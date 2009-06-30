//
//  TDTokenizer+BlobState.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 6/7/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <ParseKit/TDTokenizer.h>

@class TDBlobState;

@interface TDTokenizer (BlobState)
- (TDBlobState *)blobState;
@end
